import 'package:brewboss/core/utils/format.dart';
import 'package:brewboss/core/utils/rule_exception.dart';
import 'package:brewboss/core/utils/validators.dart';
import 'package:brewboss/features/auth/application/auth_rules.dart';
import 'package:brewboss/features/barista/application/barista_rules.dart';
import 'package:brewboss/features/inventory/application/inventory_rules.dart';
import 'package:brewboss/features/loyalty/application/loyalty_rules.dart';
import 'package:brewboss/features/menu/application/menu_rules.dart';
import 'package:brewboss/features/pos/application/order_rules.dart';
import 'package:brewboss/features/reports/application/report_rules.dart';
import 'package:brewboss/features/staff/application/staff_rules.dart';
import 'package:brewboss/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

OrderItem item({int qty = 1, int price = 10000, int batch = 1, String id = 'p1'}) =>
    OrderItem(productId: id, name: 'X', size: 'M', unitPrice: price, qty: qty, batch: batch);

Order order({OrderStatus status = OrderStatus.served, List<OrderItem>? items}) =>
    Order(id: 'o', createdBy: 'u', status: status, items: items ?? [item()]);

void main() {
  group('format', () {
    test('VND uses dot grouping', () => expect(formatVnd(45000), '45.000 ₫'));
    test('search ignores case and accents', () => expect(foldAccents('Cà Phê Đá'), 'ca phe da'));
    test('money input', () => expect(parseMoney('1.500.000'), 1500000));
    test('phone normalized', () => expect(normalizePhone('+84 912 345 678'), '0912345678'));
    test('phone validated', () {
      expect(validatePhone('0912 345 678'), isNull);
      expect(validatePhone('912345678'), isNotNull);
    });
  });

  group('routing', () {
    test('home per role', () {
      expect(homeRouteFor(UserRole.manager), '/manager');
      expect(homeRouteFor(UserRole.supervisor), '/pos');
      expect(homeRouteFor(UserRole.barista), '/barista');
    });
    test('matrix of SRS 3.1.3', () {
      expect(canOpen(UserRole.cashier, '/pos/order/1/pay'), isTrue);
      expect(canOpen(UserRole.cashier, '/manager/staff'), isFalse);
      expect(canOpen(UserRole.cashier, '/manager/menu'), isTrue);
      expect(canOpen(UserRole.cashier, '/manager/menu/1'), isFalse);
      expect(canOpen(UserRole.barista, '/pos'), isFalse);
      expect(canOpen(UserRole.supervisor, '/manager/shifts'), isTrue);
      expect(canOpen(UserRole.supervisor, '/manager/inventory/1'), isFalse);
      expect(canOpen(UserRole.supervisor, '/barista'), isTrue);
    });
  });

  group('prices', () {
    const p = Product(
      id: 'p',
      categoryId: 'c',
      name: 'Trà',
      basePrice: 45000,
      sizes: [ProductSize(code: 'S'), ProductSize(code: 'L', priceDelta: 10000)],
      toppings: [Topping(id: 't', name: 'Trân châu', price: 7000)],
    );
    test('BR-ORD-01', () => expect(unitPrice(p, 'L', const [ItemTopping(name: 'a', price: 5000)]), 60000));
    test('reprice reads current topping price', () {
      const line = OrderItem(
          productId: 'p', name: 'Trà', size: 'L', unitPrice: 60000, toppings: [ItemTopping(name: 'Trân châu', price: 5000)]);
      expect(currentUnitPrice(p, line), 62000);
    });
    test('BR-ORD-02 floors at zero', () {
      expect(totalOf(100000, 10000, 5, 1000), 85000);
      expect(totalOf(10000, 10000, 5, 1000), 0);
    });
  });

  group('order rules', () {
    test('state machine', () {
      expect(canTransition(OrderStatus.awaiting, OrderStatus.pending, UserRole.cashier), isTrue);
      expect(canTransition(OrderStatus.pending, OrderStatus.ready, UserRole.barista), isFalse);
      expect(canTransition(OrderStatus.pending, OrderStatus.preparing, UserRole.cashier), isFalse);
      expect(canTransition(OrderStatus.served, OrderStatus.paid, UserRole.barista), isFalse);
      expect(canTransition(OrderStatus.paid, OrderStatus.pending, UserRole.manager), isFalse);
    });
    test('BR-ORD-04: served reopens with a new batch', () {
      final next = addItems(order(), [item(id: 'p2')]);
      expect(next.status, OrderStatus.pending);
      expect(next.items.last.batch, 2);
    });
    test('BR-ORD-04: preparing keeps status and batch', () {
      final next = addItems(order(status: OrderStatus.preparing), [item(id: 'p2')]);
      expect(next.status, OrderStatus.preparing);
      expect(next.items.last.batch, 1);
    });
    test('BR-ORD-05', () {
      expect(canCancel(OrderStatus.pending, UserRole.cashier), isTrue);
      expect(canCancel(OrderStatus.preparing, UserRole.cashier), isFalse);
      expect(canCancel(OrderStatus.served, UserRole.supervisor), isTrue);
      expect(canCancel(OrderStatus.paid, UserRole.manager), isFalse);
    });
    test('BR-INV-02 defaults', () {
      expect(madeDefault(OrderStatus.pending), isNull);
      expect(madeDefault(OrderStatus.preparing), isFalse);
      expect(madeDefault(OrderStatus.served), isTrue);
    });
    test('BR-ORD-08', () {
      expect(canMerge(order(), order()), isTrue);
      expect(canMerge(order(), order(status: OrderStatus.preparing)), isFalse);
      expect(canMerge(order(), order().copyWith(voucherCode: 'V')), isFalse);
      expect(canMerge(order(), order().copyWith(customerId: '0912345678')), isFalse);
    });
    test('BR-PAY-01', () {
      expect(() => validatePayment(100, 60, 40), returnsNormally);
      expect(() => validatePayment(0, 0, 0), returnsNormally);
      expect(() => validatePayment(100, 50, 40), throwsA(isA<RuleException>()));
      expect(() => validatePayment(100, -1, 101), throwsA(isA<RuleException>()));
    });
    test('BR-ORD-06 short id', () {
      expect(shortIdFrom(81), 'A0081');
      expect(shortIdFrom(10001), 'B0001');
    });
    test('VietQR URL', () {
      const s = ShopSettings(bankBin: '970436', bankAccountNo: '123', bankAccountName: 'NGUYEN VAN A');
      final url = vietQrUrl(s, 50000, 'A0079')!;
      expect(url, startsWith('https://img.vietqr.io/image/970436-123-compact2.png?'));
      expect(Uri.parse(url).queryParameters['amount'], '50000');
      expect(Uri.parse(url).queryParameters['addInfo'], 'BREWBOSS A0079');
      expect(vietQrUrl(const ShopSettings(), 1, 'A'), isNull);
    });
  });

  group('loyalty', () {
    final now = DateTime(2026, 1, 1);
    Voucher v({int used = 0, int min = 0, DateTime? exp}) => Voucher(
        code: 'V',
        type: VoucherType.percent,
        value: 10,
        maxDiscount: 20000,
        minOrder: min,
        usedCount: used,
        usageLimit: 1,
        expiresAt: exp ?? DateTime(2027));
    test('voucher errors', () {
      expect(voucherError(null, 1, now), 'MSG22');
      expect(voucherError(v(exp: DateTime(2025)), 1, now), 'MSG23');
      expect(voucherError(v(used: 1), 1, now), 'MSG24');
      expect(voucherError(v(min: 5), 1, now), 'MSG25');
      expect(voucherError(v(), 1, now), isNull);
    });
    test('percent discount is capped (BR-DIS-02)', () {
      expect(voucherDiscount(v(), 100000), 10000);
      expect(voucherDiscount(v(), 500000), 20000);
    });
    test('fixed discount never exceeds subtotal', () {
      expect(voucherDiscount(const Voucher(code: 'F', type: VoucherType.fixed, value: 50000), 30000), 30000);
    });
    test('points', () {
      expect(pointsEarned(129000, 10000), 12);
      expect(maxRedeemable(120, 45000, 1000), 45);
      expect(maxRedeemable(10, 45000, 1000), 10);
    });
  });

  group('inventory', () {
    test('usage multiplies by qty and ignores other sizes', () {
      const p = Product(id: 'p1', categoryId: 'c', name: 'X', recipe: {
        'M': [RecipeItem(ingredientId: 'i', qty: 20)],
        'L': [RecipeItem(ingredientId: 'i', qty: 99)],
      });
      expect(recipeUsage([item(qty: 3)], {'p1': p}), {'i': 60});
    });
    test('a product without recipe deducts nothing', () {
      expect(recipeUsage([item()], const {}), isEmpty);
    });
    test('low stock', () {
      expect(isLowStock(const Ingredient(id: 'i', name: 'x', unit: 'g', stock: 200, minStock: 200)), isTrue);
      expect(stocktakeDiff(180, 200), -20);
    });
  });

  group('staff', () {
    test('cash rules', () {
      final paid = [order().copyWith(cashAmount: 100), order().copyWith(cashAmount: 50, qrAmount: 999)];
      expect(expectedCash(500, paid), 650);
      expect(cashDiff(630, 650), -20);
      expect(needsNote(-20), isTrue);
      expect(needsNote(0), isFalse);
      expect(canCheckIn(null), isTrue);
    });
  });

  group('barista', () {
    test('only the latest batch is current', () {
      final (current, earlier) = visibleItems(order(items: [item(), item(batch: 2, id: 'p2')]));
      expect(current.single.productId, 'p2');
      expect(earlier.single.productId, 'p1');
    });
    test('beeps on new order and on added lines only', () {
      final a = order();
      expect(shouldBeep([], [a]), isTrue);
      expect(shouldBeep([a], [a]), isFalse);
      expect(shouldBeep([a], [a.copyWith(items: [item(), item(id: 'p2')])]), isTrue);
      expect(shouldBeep([a], []), isFalse);
    });
    test('late after the threshold', () {
      final o = order().copyWith(createdAt: DateTime(2026, 1, 1, 8));
      expect(isLate(o, DateTime(2026, 1, 1, 8, 11), 10), isTrue);
      expect(isLate(o, DateTime(2026, 1, 1, 8, 10), 10), isFalse);
    });
  });

  group('reports', () {
    final a = order().copyWith(total: 100, cashAmount: 60, qrAmount: 40, paidAt: DateTime(2026, 9, 21, 10));
    final b = order().copyWith(total: 50, cashAmount: 50, paidAt: DateTime(2026, 9, 23, 10));
    test('summary', () {
      expect(summary([a, b]).average, 75);
      expect(summary(const []).average, 0);
    });
    test('buckets keep empty days', () {
      final points = byBucket([a, b], Bucket.day, DateTime(2026, 9, 21), DateTime(2026, 9, 24));
      expect(points.map((p) => p.revenue), [100, 0, 50]);
      expect(points.first.label, 'T2');
    });
    test('split', () => expect(paymentSplit([a, b]), (110, 40)));
    test('merge closures are not real cancels', () {
      final closed = order(status: OrderStatus.cancelled);
      expect(isRealCancel(closed), isTrue);
      expect(isRealCancel(closed.copyWith(mergedIntoId: 'x')), isFalse);
    });
  });
}
