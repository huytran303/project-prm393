// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String? ?? '',
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  isActive: json['isActive'] as bool? ?? true,
  fcmTokens:
      (json['fcmTokens'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'role': _$UserRoleEnumMap[instance.role]!,
  'isActive': instance.isActive,
  'fcmTokens': instance.fcmTokens,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
};

const _$UserRoleEnumMap = {
  UserRole.manager: 'manager',
  UserRole.supervisor: 'supervisor',
  UserRole.cashier: 'cashier',
  UserRole.barista: 'barista',
};

_Shift _$ShiftFromJson(Map<String, dynamic> json) => _Shift(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String? ?? '',
  userRole:
      $enumDecodeNullable(_$UserRoleEnumMap, json['userRole']) ??
      UserRole.cashier,
  checkIn: const TimestampConverter().fromJson(json['checkIn']),
  checkOut: const TimestampConverter().fromJson(json['checkOut']),
  openingCash: (json['openingCash'] as num?)?.toInt(),
  closingCash: (json['closingCash'] as num?)?.toInt(),
  expectedCash: (json['expectedCash'] as num?)?.toInt(),
  cashDiff: (json['cashDiff'] as num?)?.toInt(),
  cashSales: (json['cashSales'] as num?)?.toInt() ?? 0,
  qrSales: (json['qrSales'] as num?)?.toInt() ?? 0,
  lastPaidOrderId: json['lastPaidOrderId'] as String?,
  handoverNote: json['handoverNote'] as String?,
);

Map<String, dynamic> _$ShiftToJson(_Shift instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userName': instance.userName,
  'userRole': _$UserRoleEnumMap[instance.userRole]!,
  'checkIn': const TimestampConverter().toJson(instance.checkIn),
  'checkOut': const TimestampConverter().toJson(instance.checkOut),
  'openingCash': instance.openingCash,
  'closingCash': instance.closingCash,
  'expectedCash': instance.expectedCash,
  'cashDiff': instance.cashDiff,
  'cashSales': instance.cashSales,
  'qrSales': instance.qrSales,
  'lastPaidOrderId': instance.lastPaidOrderId,
  'handoverNote': instance.handoverNote,
};

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'sortOrder': instance.sortOrder,
};

_ProductSize _$ProductSizeFromJson(Map<String, dynamic> json) => _ProductSize(
  code: json['code'] as String,
  priceDelta: (json['priceDelta'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProductSizeToJson(_ProductSize instance) =>
    <String, dynamic>{'code': instance.code, 'priceDelta': instance.priceDelta};

_Topping _$ToppingFromJson(Map<String, dynamic> json) => _Topping(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ToppingToJson(_Topping instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
};

_RecipeItem _$RecipeItemFromJson(Map<String, dynamic> json) => _RecipeItem(
  ingredientId: json['ingredientId'] as String,
  qty: json['qty'] as num,
);

Map<String, dynamic> _$RecipeItemToJson(_RecipeItem instance) =>
    <String, dynamic>{
      'ingredientId': instance.ingredientId,
      'qty': instance.qty,
    };

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  categoryId: json['categoryId'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  basePrice: (json['basePrice'] as num?)?.toInt() ?? 0,
  imageUrl: json['imageUrl'] as String?,
  isAvailable: json['isAvailable'] as bool? ?? true,
  sizes:
      (json['sizes'] as List<dynamic>?)
          ?.map((e) => ProductSize.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  toppings:
      (json['toppings'] as List<dynamic>?)
          ?.map((e) => Topping.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  recipe:
      (json['recipe'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => RecipeItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const {},
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'categoryId': instance.categoryId,
  'name': instance.name,
  'description': instance.description,
  'basePrice': instance.basePrice,
  'imageUrl': instance.imageUrl,
  'isAvailable': instance.isAvailable,
  'sizes': instance.sizes.map((e) => e.toJson()).toList(),
  'toppings': instance.toppings.map((e) => e.toJson()).toList(),
  'recipe': instance.recipe.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
};

_Ingredient _$IngredientFromJson(Map<String, dynamic> json) => _Ingredient(
  id: json['id'] as String,
  name: json['name'] as String,
  unit: json['unit'] as String,
  stock: json['stock'] as num? ?? 0,
  minStock: json['minStock'] as num? ?? 0,
);

Map<String, dynamic> _$IngredientToJson(_Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unit': instance.unit,
      'stock': instance.stock,
      'minStock': instance.minStock,
    };

_StockMovement _$StockMovementFromJson(Map<String, dynamic> json) =>
    _StockMovement(
      id: json['id'] as String,
      type: $enumDecode(_$MovementTypeEnumMap, json['type']),
      qty: json['qty'] as num,
      orderId: json['orderId'] as String?,
      cost: (json['cost'] as num?)?.toInt(),
      reason: json['reason'] as String?,
      byUserId: json['byUserId'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$StockMovementToJson(_StockMovement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$MovementTypeEnumMap[instance.type]!,
      'qty': instance.qty,
      'orderId': instance.orderId,
      'cost': instance.cost,
      'reason': instance.reason,
      'byUserId': instance.byUserId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$MovementTypeEnumMap = {
  MovementType.stockIn: 'in',
  MovementType.sale: 'sale',
  MovementType.adjust: 'adjust',
};

_CafeTable _$CafeTableFromJson(Map<String, dynamic> json) => _CafeTable(
  id: json['id'] as String,
  name: json['name'] as String,
  area: json['area'] as String,
  capacity: (json['capacity'] as num?)?.toInt() ?? 2,
  currentOrderId: json['currentOrderId'] as String?,
);

Map<String, dynamic> _$CafeTableToJson(_CafeTable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'area': instance.area,
      'capacity': instance.capacity,
      'currentOrderId': instance.currentOrderId,
    };

_ItemTopping _$ItemToppingFromJson(Map<String, dynamic> json) => _ItemTopping(
  name: json['name'] as String,
  price: (json['price'] as num).toInt(),
);

Map<String, dynamic> _$ItemToppingToJson(_ItemTopping instance) =>
    <String, dynamic>{'name': instance.name, 'price': instance.price};

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  productId: json['productId'] as String,
  name: json['name'] as String,
  size: json['size'] as String,
  toppings:
      (json['toppings'] as List<dynamic>?)
          ?.map((e) => ItemTopping.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  unitPrice: (json['unitPrice'] as num).toInt(),
  qty: (json['qty'] as num?)?.toInt() ?? 1,
  note: json['note'] as String? ?? '',
  batch: (json['batch'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'size': instance.size,
      'toppings': instance.toppings.map((e) => e.toJson()).toList(),
      'unitPrice': instance.unitPrice,
      'qty': instance.qty,
      'note': instance.note,
      'batch': instance.batch,
    };

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  shortId: json['shortId'] as String?,
  tableId: json['tableId'] as String?,
  source:
      $enumDecodeNullable(_$OrderSourceEnumMap, json['source']) ??
      OrderSource.staff,
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.pending,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subtotal: (json['subtotal'] as num?)?.toInt() ?? 0,
  discount: (json['discount'] as num?)?.toInt() ?? 0,
  voucherCode: json['voucherCode'] as String?,
  pointsRedeemed: (json['pointsRedeemed'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  cashAmount: (json['cashAmount'] as num?)?.toInt() ?? 0,
  qrAmount: (json['qrAmount'] as num?)?.toInt() ?? 0,
  paidBy: json['paidBy'] as String?,
  shiftId: json['shiftId'] as String?,
  customerId: json['customerId'] as String?,
  createdBy: json['createdBy'] as String,
  cancelReason: json['cancelReason'] as String?,
  cancelledBy: json['cancelledBy'] as String?,
  confirmedBy: json['confirmedBy'] as String?,
  confirmedAt: const TimestampConverter().fromJson(json['confirmedAt']),
  mergedIntoId: json['mergedIntoId'] as String?,
  followerUids:
      (json['followerUids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  updatedBy: json['updatedBy'] as String?,
  paidAt: const TimestampConverter().fromJson(json['paidAt']),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'shortId': instance.shortId,
  'tableId': instance.tableId,
  'source': _$OrderSourceEnumMap[instance.source]!,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'subtotal': instance.subtotal,
  'discount': instance.discount,
  'voucherCode': instance.voucherCode,
  'pointsRedeemed': instance.pointsRedeemed,
  'total': instance.total,
  'cashAmount': instance.cashAmount,
  'qrAmount': instance.qrAmount,
  'paidBy': instance.paidBy,
  'shiftId': instance.shiftId,
  'customerId': instance.customerId,
  'createdBy': instance.createdBy,
  'cancelReason': instance.cancelReason,
  'cancelledBy': instance.cancelledBy,
  'confirmedBy': instance.confirmedBy,
  'confirmedAt': const TimestampConverter().toJson(instance.confirmedAt),
  'mergedIntoId': instance.mergedIntoId,
  'followerUids': instance.followerUids,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'updatedBy': instance.updatedBy,
  'paidAt': const TimestampConverter().toJson(instance.paidAt),
};

const _$OrderSourceEnumMap = {
  OrderSource.staff: 'staff',
  OrderSource.customer: 'customer',
};

const _$OrderStatusEnumMap = {
  OrderStatus.awaiting: 'awaiting',
  OrderStatus.pending: 'pending',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.served: 'served',
  OrderStatus.paid: 'paid',
  OrderStatus.cancelled: 'cancelled',
};

_Customer _$CustomerFromJson(Map<String, dynamic> json) => _Customer(
  id: json['id'] as String,
  name: json['name'] as String?,
  phone: json['phone'] as String,
  points: (json['points'] as num?)?.toInt() ?? 0,
  visitCount: (json['visitCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'points': instance.points,
  'visitCount': instance.visitCount,
};

_Voucher _$VoucherFromJson(Map<String, dynamic> json) => _Voucher(
  code: json['code'] as String,
  type: $enumDecode(_$VoucherTypeEnumMap, json['type']),
  value: (json['value'] as num).toInt(),
  minOrder: (json['minOrder'] as num?)?.toInt() ?? 0,
  maxDiscount: (json['maxDiscount'] as num?)?.toInt(),
  expiresAt: const TimestampConverter().fromJson(json['expiresAt']),
  usageLimit: (json['usageLimit'] as num?)?.toInt() ?? 1,
  usedCount: (json['usedCount'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$VoucherToJson(_Voucher instance) => <String, dynamic>{
  'code': instance.code,
  'type': _$VoucherTypeEnumMap[instance.type]!,
  'value': instance.value,
  'minOrder': instance.minOrder,
  'maxDiscount': instance.maxDiscount,
  'expiresAt': const TimestampConverter().toJson(instance.expiresAt),
  'usageLimit': instance.usageLimit,
  'usedCount': instance.usedCount,
  'isActive': instance.isActive,
};

const _$VoucherTypeEnumMap = {
  VoucherType.percent: 'percent',
  VoucherType.fixed: 'fixed',
};

_ShopSettings _$ShopSettingsFromJson(Map<String, dynamic> json) =>
    _ShopSettings(
      name: json['name'] as String? ?? 'BrewBoss',
      address: json['address'] as String? ?? '',
      bankBin: json['bankBin'] as String? ?? '',
      bankAccountNo: json['bankAccountNo'] as String? ?? '',
      bankAccountName: json['bankAccountName'] as String? ?? '',
      lateOrderMinutes: (json['lateOrderMinutes'] as num?)?.toInt() ?? 10,
      pointsPerVnd: (json['pointsPerVnd'] as num?)?.toInt() ?? 10000,
      vndPerPoint: (json['vndPerPoint'] as num?)?.toInt() ?? 1000,
    );

Map<String, dynamic> _$ShopSettingsToJson(_ShopSettings instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'bankBin': instance.bankBin,
      'bankAccountNo': instance.bankAccountNo,
      'bankAccountName': instance.bankAccountName,
      'lateOrderMinutes': instance.lateOrderMinutes,
      'pointsPerVnd': instance.pointsPerVnd,
      'vndPerPoint': instance.vndPerPoint,
    };
