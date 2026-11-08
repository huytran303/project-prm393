import '../../../core/router/routes.dart';
import '../../../models/models.dart';

/// Home screen of each role (BR-AUTH-ROUTE).
String homeRouteFor(UserRole role) => switch (role) {
      UserRole.manager => Routes.manager,
      UserRole.supervisor || UserRole.cashier => Routes.pos,
      UserRole.barista => Routes.barista,
    };

/// Screen authorization matrix of SRS 3.1.3.
bool canOpen(UserRole role, String location) {
  if (role == UserRole.manager) return true;
  if (location == Routes.profile || location == Routes.shift || location == Routes.menu) return true;
  final isPos = location == Routes.pos || location.startsWith('${Routes.pos}/');
  return switch (role) {
    UserRole.manager => true,
    UserRole.supervisor =>
      isPos || location == Routes.barista || location == Routes.shifts || location == Routes.inventory,
    UserRole.cashier => isPos,
    UserRole.barista => location == Routes.barista,
  };
}
