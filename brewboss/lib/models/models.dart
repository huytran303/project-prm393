import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/utils/timestamp_converter.dart';

part 'models.freezed.dart';
part 'models.g.dart';

enum UserRole {
  manager('Quản lý'),
  supervisor('Trưởng ca'),
  cashier('Thu ngân'),
  barista('Pha chế');

  const UserRole(this.label);
  final String label;

  /// Barista shifts have no cash fields (BR-STAFF-03).
  bool get handlesCash => this != UserRole.barista;
}

enum OrderStatus {
  awaiting('Chờ xác nhận'),
  pending('Chờ pha'),
  preparing('Đang pha'),
  ready('Sẵn sàng'),
  served('Đã phục vụ'),
  paid('Đã thanh toán'),
  cancelled('Đã hủy');

  const OrderStatus(this.label);
  final String label;
}

enum OrderSource { staff, customer }

@JsonEnum()
enum MovementType {
  @JsonValue('in')
  stockIn('Nhập kho'),
  sale('Bán hàng'),
  adjust('Điều chỉnh');

  const MovementType(this.label);
  final String label;
}

enum VoucherType { percent, fixed }

/// Adds the document id so `fromJson` can fill the `id` field.
Map<String, dynamic> withId(DocumentSnapshot<Map<String, dynamic>> doc) =>
    {...?doc.data(), 'id': doc.id};

/// Serialized form without the id, which is never stored as a field.
Map<String, dynamic> toDoc(Map<String, dynamic> json) => json..remove('id');

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String name,
    required String email,
    @Default('') String phone,
    required UserRole role,
    @Default(true) bool isActive,
    @Default([]) List<String> fcmTokens,
    @TimestampConverter() DateTime? createdAt,
  }) = _AppUser;
  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}

@freezed
abstract class Shift with _$Shift {
  const factory Shift({
    required String id,
    required String userId,
    @Default('') String userName,
    @Default(UserRole.cashier) UserRole userRole,
    @TimestampConverter() DateTime? checkIn,
    @TimestampConverter() DateTime? checkOut,
    int? openingCash,
    int? closingCash,
    int? expectedCash,
    int? cashDiff,
    @Default(0) int cashSales,
    @Default(0) int qrSales,
    String? lastPaidOrderId,
    String? handoverNote,
  }) = _Shift;
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}

@freezed
abstract class Category with _$Category {
  const factory Category({required String id, required String name, @Default(0) int sortOrder}) = _Category;
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
abstract class ProductSize with _$ProductSize {
  const factory ProductSize({required String code, @Default(0) int priceDelta}) = _ProductSize;
  factory ProductSize.fromJson(Map<String, dynamic> json) => _$ProductSizeFromJson(json);
}

@freezed
abstract class Topping with _$Topping {
  const factory Topping({required String id, required String name, @Default(0) int price}) = _Topping;
  factory Topping.fromJson(Map<String, dynamic> json) => _$ToppingFromJson(json);
}

@freezed
abstract class RecipeItem with _$RecipeItem {
  const factory RecipeItem({required String ingredientId, required num qty}) = _RecipeItem;
  factory RecipeItem.fromJson(Map<String, dynamic> json) => _$RecipeItemFromJson(json);
}

@freezed
abstract class Product with _$Product {
  const Product._();
  const factory Product({
    required String id,
    required String categoryId,
    required String name,
    @Default('') String description,
    @Default(0) int basePrice,
    String? imageUrl,
    @Default(true) bool isAvailable,
    @Default([]) List<ProductSize> sizes,
    @Default([]) List<Topping> toppings,
    @Default({}) Map<String, List<RecipeItem>> recipe,
  }) = _Product;
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  /// Lowest selling price, shown as "từ 29.000 ₫".
  int get fromPrice => sizes.isEmpty
      ? basePrice
      : basePrice + sizes.map((s) => s.priceDelta).reduce((a, b) => a < b ? a : b);
}

@freezed
abstract class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String id,
    required String name,
    required String unit,
    @Default(0) num stock,
    @Default(0) num minStock,
  }) = _Ingredient;
  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
}

@freezed
abstract class StockMovement with _$StockMovement {
  const factory StockMovement({
    required String id,
    required MovementType type,
    required num qty,
    String? orderId,
    int? cost,
    String? reason,
    required String byUserId,
    @TimestampConverter() DateTime? createdAt,
  }) = _StockMovement;
  factory StockMovement.fromJson(Map<String, dynamic> json) => _$StockMovementFromJson(json);
}

@freezed
abstract class CafeTable with _$CafeTable {
  const factory CafeTable({
    required String id,
    required String name,
    required String area,
    @Default(2) int capacity,
    String? currentOrderId,
  }) = _CafeTable;
  factory CafeTable.fromJson(Map<String, dynamic> json) => _$CafeTableFromJson(json);
}

@freezed
abstract class ItemTopping with _$ItemTopping {
  const factory ItemTopping({required String name, required int price}) = _ItemTopping;
  factory ItemTopping.fromJson(Map<String, dynamic> json) => _$ItemToppingFromJson(json);
}

@freezed
abstract class OrderItem with _$OrderItem {
  const OrderItem._();
  const factory OrderItem({
    required String productId,
    required String name,
    required String size,
    @Default([]) List<ItemTopping> toppings,
    required int unitPrice,
    @Default(1) int qty,
    @Default('') String note,
    @Default(1) int batch,
  }) = _OrderItem;
  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  int get lineTotal => unitPrice * qty;

  /// "2× Cà phê sữa đá (M) + Trân châu"
  String get label {
    final extras = toppings.map((t) => ' + ${t.name}').join();
    return '$qty× $name ($size)$extras';
  }
}

@freezed
abstract class Order with _$Order {
  const Order._();
  const factory Order({
    required String id,
    String? shortId,
    String? tableId,
    @Default(OrderSource.staff) OrderSource source,
    @Default(OrderStatus.pending) OrderStatus status,
    @Default([]) List<OrderItem> items,
    @Default(0) int subtotal,
    @Default(0) int discount,
    String? voucherCode,
    @Default(0) int pointsRedeemed,
    @Default(0) int total,
    @Default(0) int cashAmount,
    @Default(0) int qrAmount,
    String? paidBy,
    String? shiftId,
    String? customerId,
    required String createdBy,
    String? cancelReason,
    String? cancelledBy,
    String? confirmedBy,
    @TimestampConverter() DateTime? confirmedAt,
    String? mergedIntoId,
    @Default([]) List<String> followerUids,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    String? updatedBy,
    @TimestampConverter() DateTime? paidAt,
  }) = _Order;
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  int get itemCount => items.fold(0, (sum, i) => sum + i.qty);
  bool get isTakeaway => tableId == null;
  String get code => shortId ?? 'Chờ xác nhận';
}

@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    required String id,
    String? name,
    required String phone,
    @Default(0) int points,
    @Default(0) int visitCount,
  }) = _Customer;
  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}

@freezed
abstract class Voucher with _$Voucher {
  const factory Voucher({
    required String code,
    required VoucherType type,
    required int value,
    @Default(0) int minOrder,
    int? maxDiscount,
    @TimestampConverter() DateTime? expiresAt,
    @Default(1) int usageLimit,
    @Default(0) int usedCount,
    @Default(true) bool isActive,
  }) = _Voucher;
  factory Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);
}

@freezed
abstract class ShopSettings with _$ShopSettings {
  const ShopSettings._();
  const factory ShopSettings({
    @Default('BrewBoss') String name,
    @Default('') String address,
    @Default('') String bankBin,
    @Default('') String bankAccountNo,
    @Default('') String bankAccountName,
    @Default(10) int lateOrderMinutes,
    @Default(10000) int pointsPerVnd,
    @Default(1000) int vndPerPoint,
  }) = _ShopSettings;
  factory ShopSettings.fromJson(Map<String, dynamic> json) => _$ShopSettingsFromJson(json);

  bool get hasBankAccount => bankBin.isNotEmpty && bankAccountNo.isNotEmpty;
}

/// Cash handover preview of the check-out sheet (SD-07).
class CashSummary {
  const CashSummary({required this.opening, required this.cashSales, required this.qrSales});
  final int opening;
  final int cashSales;
  final int qrSales;
  int get expected => opening + cashSales;
}

/// Amounts collected on S15.
class PaymentInput {
  const PaymentInput({required this.cash, required this.qr});
  final int cash;
  final int qr;
}
