class Routes {
  static const splash = '/';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const profile = '/profile';
  static const shift = '/shift';
  static const manager = '/manager';
  static const staff = '/manager/staff';
  static const shifts = '/manager/shifts';
  static const menu = '/manager/menu';
  static const inventory = '/manager/inventory';
  static const tables = '/manager/tables';
  static const reports = '/manager/reports';
  static const orders = '/manager/orders';
  static const loyalty = '/manager/loyalty';
  static const pos = '/pos';
  static const barista = '/barista';

  static String order(String id) => '/pos/order/$id';
  static String pay(String id) => '/pos/order/$id/pay';
  static String customerMenu(String tableId) => '/c/$tableId';
  static String customerOrder(String tableId, String orderId) => '/c/$tableId/order/$orderId';
}
