// End-to-end run of the main business flow against the Firebase Emulator Suite.
//   firebase emulators:start --only auth,firestore,storage --project demo-brewboss
//   (cd functions && npm run seed)
//   flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d <device>
import 'package:brewboss/core/router/app_router.dart';
import 'package:brewboss/core/widgets/widgets.dart';
import 'package:brewboss/main.dart' as app;
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('order to payment across every role', (tester) async {
    await app.main();
    await binding.convertFlutterSurfaceToImage();
    final db = FirebaseFirestore.instance;

    Future<void> until(Finder f, {int seconds = 25}) async {
      final end = DateTime.now().add(Duration(seconds: seconds));
      while (DateTime.now().isBefore(end)) {
        await tester.pump(const Duration(milliseconds: 150));
        if (f.evaluate().isNotEmpty) return;
      }
      fail('Not found in ${seconds}s: $f');
    }

    Future<void> settle([int ms = 600]) async {
      for (var i = 0; i < ms ~/ 100; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    Future<void> shot(String name) async {
      await settle();
      await binding.takeScreenshot(name);
    }

    Future<void> tap(Finder f) async {
      await until(f);
      await tester.ensureVisible(f.first);
      await settle(200);
      await tester.tap(f.first);
      await settle();
    }

    Future<void> tapText(String text) => tap(find.text(text));

    Finder field(String label) =>
        find.descendant(of: find.widgetWithText(LabeledField, label), matching: find.byType(TextField));

    Future<void> enter(Finder f, String text) async {
      await until(f);
      await tester.ensureVisible(f.first);
      await tester.enterText(f.first, text);
      await settle(200);
    }

    GoRouter router() => ProviderScope.containerOf(tester.element(find.byType(Scaffold).first)).read(routerProvider);

    void clearSnackBars() => tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger).first).clearSnackBars();

    Future<void> go(String route) async {
      clearSnackBars();
      router().go(route);
      await settle(1000);
    }

    Future<void> login(String email) async {
      clearSnackBars();
      await FirebaseAuth.instance.signOut();
      await settle();
      router().go('/login'); // Public customer routes do not redirect by themselves.
      await until(find.text('Dành cho nhân viên BrewBoss'));
      await enter(field('Email *'), email);
      await enter(field('Mật khẩu *'), '123456');
      await tap(find.widgetWithText(FilledButton, 'Đăng nhập'));
    }

    Future<Map<String, dynamic>> orderOf(String id) async => (await db.doc('orders/$id').get()).data()!;

    Future<void> pick(String product, {String? topping}) async {
      await tapText(product);
      await until(find.textContaining('Thêm ·'));
      if (topping != null) await tapText(topping);
      await tap(find.textContaining('Thêm ·'));
    }

    // ── Bad credentials show MSG01; the screen stays on login.
    await until(find.text('Dành cho nhân viên BrewBoss'));
    await shot('s02_login');
    await enter(field('Email *'), 'lan@brewboss.vn');
    await enter(field('Mật khẩu *'), 'wrong-password');
    await tap(find.widgetWithText(FilledButton, 'Đăng nhập'));
    await until(find.text('Email hoặc mật khẩu không đúng. Vui lòng thử lại.'));

    // ── Deactivated account shows MSG03.
    await enter(field('Email *'), 'thanh@brewboss.vn');
    await enter(field('Mật khẩu *'), '123456');
    await tap(find.widgetWithText(FilledButton, 'Đăng nhập'));
    await until(find.text('Tài khoản đã bị vô hiệu hóa. Liên hệ quản lý.'));

    // ── Cashier: check in, create an order for T3.
    await login('lan@brewboss.vn');
    await tapText('Trong nhà');
    await shot('s13_table_map');
    await tap(find.byTooltip('Ca làm của tôi'));
    await until(find.text('Chưa vào ca'));
    await enter(find.byType(TextFormField), '500000');
    await shot('s07_check_in');
    await tap(find.widgetWithText(FilledButton, 'Vào ca'));
    await until(find.text('Đang trong ca'));
    await shot('s07_in_shift');
    await go('/pos');

    await tapText('Trong nhà');
    await tapText('T3');
    await until(find.text('Đơn mới'));
    await tapText('Cà phê sữa đá');
    await until(find.textContaining('Thêm ·'));
    await shot('s14_item_options');
    await tapText('M +5.000');
    await tapText('Trân châu');
    await tap(find.textContaining('Thêm ·'));
    await pick('Bạc xỉu');
    await shot('s14_order_editor');
    await tap(find.widgetWithText(FilledButton, 'Gửi pha chế'));
    await until(find.textContaining('Chờ pha · sửa được'));

    final tables = await db.collection('tables').get();
    final t3 = tables.docs.firstWhere((d) => d.get('name') == 'T3');
    final t5 = tables.docs.firstWhere((d) => d.get('name') == 'T5');
    final orderId = (await t3.reference.get()).get('currentOrderId') as String;
    final created = await orderOf(orderId);
    expect(created['status'], 'pending');
    expect(created['shortId'], 'A0001');
    expect(created['subtotal'], 29000 + 5000 + 5000 + 32000);

    // ── A second order on the same table is rejected (BR-ORD-03).
    await go('/pos/order/new?table=${t3.id}');
    await until(find.text('Đơn mới'));
    await pick('Americano');
    await tap(find.widgetWithText(FilledButton, 'Gửi pha chế'));
    await until(find.text('Bàn đã có đơn'));
    await go('/pos');
    await until(find.text('Sơ đồ bàn'));
    await tapText('Trong nhà');
    await shot('s13_with_order');

    // ── Barista: start and finish. The cashier cannot open this screen.
    await login('minh@brewboss.vn');
    await until(find.text('Hàng đợi pha chế'));
    await tapText('Bắt đầu');
    await until(find.text('Xong'));
    await shot('s16_barista');
    await tapText('Xong');
    await until(find.text('Hoàn tác'));
    expect((await orderOf(orderId))['status'], 'ready');
    await go('/manager/staff');
    await until(find.text('Hàng đợi pha chế')); // Role guard sends the barista home.

    // ── Customer: QR order on free table T5, as an anonymous session.
    await FirebaseAuth.instance.signOut();
    await until(find.text('Dành cho nhân viên BrewBoss'));
    await go('/c/${t5.id}');
    await until(find.text('Bạn đang ngồi bàn T5'));
    await until(find.text('Trà đào cam sả'));
    await tap(find.byTooltip('Thêm Trà đào cam sả'));
    await until(find.textContaining('Thêm ·'));
    await tap(find.textContaining('Thêm ·'));
    await shot('s17_customer_menu');
    await tap(find.textContaining('Đặt món ·'));
    await until(find.text('Xem trạng thái'));
    await tapText('Xem trạng thái');
    await until(find.text('Đang chờ nhân viên xác nhận'));
    await shot('s18_customer_awaiting');
    final customerUid = FirebaseAuth.instance.currentUser!.uid;
    expect(FirebaseAuth.instance.currentUser!.isAnonymous, isTrue);
    final qr = await db.collection('orders').where('createdBy', isEqualTo: customerUid).get();
    final qrId = qr.docs.single.id;
    expect(qr.docs.single.get('shortId'), isNull);

    // ── Cashier: confirm QR, serve T3, voucher + loyalty + split payment.
    await login('lan@brewboss.vn');
    await until(find.textContaining('Khách tự đặt'));
    await shot('s13_customer_banner');
    await tap(find.widgetWithText(FilledButton, 'Xem').first);
    await until(find.text('MÓN KHÁCH ĐẶT'));
    await shot('s14_customer_review');
    await tap(find.widgetWithText(FilledButton, 'Xác nhận'));
    await until(find.text('Sơ đồ bàn'));
    final confirmed = await orderOf(qrId);
    expect(confirmed['status'], 'pending');
    expect(confirmed['shortId'], 'A0002');
    expect((await t5.reference.get()).get('currentOrderId'), qrId);

    await go('/pos/order/$orderId');
    await tap(find.widgetWithText(FilledButton, 'Đã phục vụ'));
    await tap(find.widgetWithText(FilledButton, 'Thanh toán'));
    await until(find.text('Tổng cộng'));

    final ingredientBefore = (await db.doc('ingredients/coffee').get()).get('stock') as num;
    await enter(find.widgetWithText(TextField, 'Mã voucher'), 'KHONGCO');
    await tap(find.widgetWithText(OutlinedButton, 'Áp dụng'));
    await until(find.text('Mã không tồn tại'));
    await enter(find.widgetWithText(TextField, 'Mã voucher'), 'CHAOBAN');
    await tap(find.widgetWithText(OutlinedButton, 'Áp dụng'));
    await until(find.text('Voucher (CHAOBAN)'));

    await tapText('Thêm khách thân thiết');
    await enter(field('Số điện thoại'), '0912 345 678');
    await tap(find.widgetWithText(OutlinedButton, 'Tìm'));
    await tap(find.widgetWithText(FilledButton, 'Gắn khách vào đơn'));
    await until(find.textContaining('Anh Tuấn'));
    await enter(find.byWidgetPredicate((w) => w is TextField && w.decoration?.hintText?.startsWith('Dùng điểm') == true), '10');
    await tap(find.widgetWithText(OutlinedButton, 'Dùng'));
    await until(find.text('Đổi 10 điểm'));
    // 71.000 − 15.000 voucher − 10.000 points = 46.000.
    expect((await orderOf(orderId))['total'], 46000);

    await tapText('Kết hợp');
    await enter(field('Phần chuyển khoản (VietQR)'), '16000');
    await enter(field('Khách đưa'), '50000');
    await shot('s15_payment_split');
    await tap(find.widgetWithText(FilledButton, 'Xác nhận thanh toán'));
    await until(find.text('Chia sẻ'));
    await shot('s15_receipt');

    final paid = await orderOf(orderId);
    expect(paid['status'], 'paid');
    expect(paid['cashAmount'], 30000);
    expect(paid['qrAmount'], 16000);
    expect(paid['paidBy'], FirebaseAuth.instance.currentUser!.uid);
    expect((await t3.reference.get()).get('currentOrderId'), isNull);
    expect((await db.doc('vouchers/CHAOBAN').get()).get('usedCount'), 89);
    final customer = (await db.doc('customers/0912345678').get()).data()!;
    expect(customer['points'], 120 - 10 + 4); // floor(46.000 / 10.000) earned.
    expect(customer['visitCount'], 25);
    // CPSĐ size M = 25 g, Bạc xỉu size S = 10 g.
    expect((await db.doc('ingredients/coffee').get()).get('stock'), ingredientBefore - 35);
    final movements = await db.collection('ingredients/coffee/movements').get();
    expect(movements.docs.single.get('type'), 'sale');
    final shift = await db.doc('shifts/${paid['shiftId']}').get();
    expect(shift.get('cashSales'), 30000);
    expect(shift.get('qrSales'), 16000);

    // Closing the receipt returns to the table map.
    await tester.tapAt(const Offset(200, 40));
    await until(find.text('Sơ đồ bàn'));

    // ── Check-out with a shortage requires a note (MSG43).
    await go('/shift');
    await tapText('Kết thúc ca');
    await until(find.text('Kết ca · Bàn giao tiền'));
    await until(find.text('Tiền mặt dự kiến'));
    await enter(field('Tiền mặt đếm được'), '510000');
    await until(find.text('Thiếu 20.000 ₫'));
    await tap(find.widgetWithText(FilledButton, 'Xác nhận check-out'));
    await until(find.text('Vui lòng nhập ghi chú cho khoản chênh lệch'));
    await enter(field('Ghi chú (bắt buộc khi có chênh lệch)'), 'Thối nhầm tiền cho khách');
    await shot('s07_handover');
    await tap(find.widgetWithText(FilledButton, 'Xác nhận check-out'));
    await until(find.text('Chưa vào ca'));
    final closed = await db.doc('shifts/${paid['shiftId']}').get();
    expect(closed.get('expectedCash'), 530000);
    expect(closed.get('cashDiff'), -20000);

    // ── Manager: dashboard reflects the sale; every screen opens without errors.
    await login('quan@brewboss.vn');
    await until(find.text('Tổng quan'));
    await until(find.text('46.000 ₫'));
    await shot('s04_dashboard');
    for (final (route, title, name) in const [
      ('/manager/staff', 'Nhân viên', 's05_staff'),
      ('/manager/shifts', 'Lịch sử ca làm', 's06_shifts'),
      ('/manager/menu', 'Thực đơn', 's08_menu'),
      ('/manager/inventory', 'Kho nguyên liệu', 's10_inventory'),
      ('/manager/tables', 'Quản lý bàn', 's12_tables'),
      ('/manager/reports', 'Báo cáo', 's19_reports'),
      ('/manager/orders', 'Lịch sử đơn hàng', 's20_orders'),
      ('/manager/loyalty', 'Khách hàng & Voucher', 's21_customers'),
      ('/profile', 'Tài khoản', 's22_profile'),
    ]) {
      await go(route);
      await until(find.text(title));
      await shot(name);
    }

    await go('/manager/inventory/coffee');
    await until(find.text('Cà phê hạt'));
    await until(find.text('Bán hàng'));
    await shot('s11_stock_history');
    await tapText('+ Nhập kho');
    await enter(field('Số lượng (g) *'), '2000');
    await shot('s11_stock_in');
    await tap(find.widgetWithText(FilledButton, 'Lưu'));
    await settle(1500);
    expect((await db.doc('ingredients/coffee').get()).get('stock'), ingredientBefore - 35 + 2000);

    await go('/manager/loyalty');
    await tapText('Voucher');
    await until(find.text('GIAM10'));
    await shot('s21_vouchers');

    final products = await db.collection('products').where('name', isEqualTo: 'Cà phê sữa đá').get();
    await go('/manager/menu/${products.docs.single.id}');
    await until(find.text('Sửa món'));
    await until(find.text('CÔNG THỨC'));
    await shot('s09_product_form');

    await go('/manager/staff');
    await tapText('Trần Thị Lan');
    await until(find.text('Sửa nhân viên'));
    await shot('s05_staff_form');
    await tap(find.byTooltip('Đóng'));

    // ── Manager creates a staff account through the secondary app and stays signed in.
    final managerUid = FirebaseAuth.instance.currentUser!.uid;
    await tap(find.byTooltip('Thêm nhân viên'));
    await enter(field('Họ tên *'), 'Nhân Viên Mới');
    await enter(field('Email *'), 'moi${DateTime.now().millisecondsSinceEpoch}@brewboss.vn');
    await enter(field('Số điện thoại *'), '0901 111 222');
    await enter(field('Mật khẩu tạm *'), 'tam12345');
    await tapText('Lưu');
    await until(find.text('Nhân Viên Mới'));
    expect(FirebaseAuth.instance.currentUser!.uid, managerUid);
    await FirebaseAuth.instance.signOut();
    await settle(800);
  });
}
