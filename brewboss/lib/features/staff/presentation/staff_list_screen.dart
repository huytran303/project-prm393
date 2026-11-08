import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../application/staff_providers.dart';
import 'staff_form_screen.dart';

final _queryProvider = StateProvider.autoDispose((_) => '');
final _roleProvider = StateProvider.autoDispose<UserRole?>((_) => null);

class StaffListScreen extends ConsumerWidget {
  const StaffListScreen({super.key});

  void _open(BuildContext context, [AppUser? user]) => Navigator.of(context)
      .push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => StaffFormScreen(user: user)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = foldAccents(ref.watch(_queryProvider));
    final role = ref.watch(_roleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Nhân viên')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Thêm nhân viên',
        onPressed: () => _open(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(children: [
          SearchField(hint: 'Tìm theo tên, email', onChanged: (v) => ref.read(_queryProvider.notifier).state = v),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: PillFilter<UserRole?>(
              options: {null: 'Tất cả', for (final r in UserRole.values) r: r.label},
              selected: role,
              onSelected: (r) => ref.read(_roleProvider.notifier).state = r,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: AsyncBody(ref.watch(staffListProvider), retry: staffListProvider, builder: (staff) {
              final rows = staff
                  .where((u) => role == null || u.role == role)
                  .where((u) => foldAccents('${u.name} ${u.email}').contains(query))
                  .toList();
              if (rows.isEmpty) return const EmptyView('Không có nhân viên nào');
              return ListView(children: [
                for (final u in rows)
                  ListRow(
                    title: u.name,
                    subtitle: u.email,
                    dimmed: !u.isActive,
                    leading: InitialAvatar(u.name),
                    onTap: () => _open(context, u),
                    trailing: !u.isActive
                        ? const StatusBadge('Đã khóa', style: BadgeStyle.red)
                        : StatusBadge(u.role.label,
                            style: u.role == UserRole.manager ? BadgeStyle.dark : BadgeStyle.light),
                  ),
              ]);
            }),
          ),
        ]),
      ),
    );
  }
}
