import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../application/menu_controller.dart';
import '../application/menu_providers.dart';
import '../application/menu_rules.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});
  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this)..addListener(() => setState(() {}));
  bool _reordering = false;

  void _showError() {
    if (mounted) showMessage(context, ErrorMapper.message(ref.read(menuControllerProvider).error));
  }

  Future<void> _categoryForm([Category? c]) async {
    final categories = ref.read(categoriesProvider).valueOrNull ?? const <Category>[];
    final name = await reasonDialog(context,
        title: c == null ? 'Thêm danh mục' : 'Đổi tên danh mục',
        label: c?.name ?? 'Tên danh mục',
        emptyError: 'Vui lòng nhập tên',
        confirm: 'Lưu');
    if (name == null) return;
    final ok = await ref
        .read(menuControllerProvider.notifier)
        .saveCategory(Category(id: c?.id ?? '', name: name, sortOrder: c?.sortOrder ?? categories.length));
    if (!ok) _showError();
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(currentUserProvider).valueOrNull?.role;
    final isManager = role == UserRole.manager;
    final onCategories = _tabs.index == 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực đơn'),
        actions: [
          if (isManager && onCategories)
            IconButton(
              tooltip: 'Sắp xếp danh mục',
              icon: Icon(_reordering ? Icons.check : Icons.swap_vert),
              onPressed: () => setState(() => _reordering = !_reordering),
            ),
        ],
        bottom: TabBar(controller: _tabs, tabs: const [Tab(text: 'Món'), Tab(text: 'Danh mục')]),
      ),
      floatingActionButton: !isManager
          ? null
          : FloatingActionButton(
              tooltip: onCategories ? 'Thêm danh mục' : 'Thêm món',
              onPressed: () => onCategories ? _categoryForm() : context.push('${Routes.menu}/new'),
              child: const Icon(Icons.add),
            ),
      body: TabBarView(controller: _tabs, children: [
        _ProductTab(isManager: isManager, canToggle: role != null && role != UserRole.barista, onError: _showError),
        _CategoryTab(isManager: isManager, reordering: _reordering, onEdit: _categoryForm, onError: _showError),
      ]),
    );
  }
}

class _ProductTab extends ConsumerStatefulWidget {
  const _ProductTab({required this.isManager, required this.canToggle, required this.onError});
  final bool isManager;
  final bool canToggle;
  final VoidCallback onError;
  @override
  ConsumerState<_ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends ConsumerState<_ProductTab> {
  String? _categoryId;
  String _text = '';

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const <Category>[];
    final names = {for (final c in categories) c.id: c.name};
    final products = ref.watch(menuQueryProvider(MenuQuery(categoryId: _categoryId, text: _text)));
    return AsyncBody(ref.watch(productsProvider), retry: productsProvider, builder: (_) {
      return ListView(padding: pagePadding, children: [
        SearchField(hint: 'Tìm món', onChanged: (v) => setState(() => _text = v)),
        const SizedBox(height: 10),
        PillFilter<String?>(
          options: {null: 'Tất cả', ...names},
          selected: _categoryId,
          onSelected: (c) => setState(() => _categoryId = c),
        ),
        const SizedBox(height: 6),
        if (products.isEmpty) EmptyView(msg('MSG12')),
        for (final p in products)
          ListRow(
            title: p.name,
            dimmed: !p.isAvailable,
            subtitle:
                '${names[p.categoryId] ?? ''} · từ ${formatVnd(p.fromPrice)}${p.isAvailable ? '' : ' · Hết hàng'}',
            leading: SizedBox(width: 52, height: 52, child: ProductImage(p.imageUrl)),
            onTap: widget.isManager ? () => context.push('${Routes.menu}/${p.id}') : null,
            trailing: Switch(
              value: p.isAvailable,
              onChanged: !widget.canToggle
                  ? null
                  : (v) async {
                      final ok = await ref.read(menuControllerProvider.notifier).setAvailable(p.id, v);
                      if (!ok) widget.onError();
                    },
            ),
          ),
        if (widget.canToggle)
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 72),
            child: Text('Công tắc = đang bán / hết hàng', style: TextStyle(color: AppColors.muted, fontSize: 13)),
          ),
      ]);
    });
  }
}

class _CategoryTab extends ConsumerWidget {
  const _CategoryTab({required this.isManager, required this.reordering, required this.onEdit, required this.onError});
  final bool isManager;
  final bool reordering;
  final void Function(Category) onEdit;
  final VoidCallback onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncBody(ref.watch(categoriesProvider), retry: categoriesProvider, builder: (categories) {
      if (categories.isEmpty) return const EmptyView('Chưa có danh mục nào');
      if (reordering) {
        return ReorderableListView(
          padding: pagePadding,
          onReorderItem: (from, to) async {
            final list = [...categories];
            list.insert(to, list.removeAt(from));
            final ok = await ref.read(menuControllerProvider.notifier).reorder(list);
            if (!ok) onError();
          },
          children: [
            for (final c in categories)
              ListRow(key: ValueKey(c.id), title: c.name, trailing: const Icon(Icons.drag_handle)),
          ],
        );
      }
      final products = ref.watch(productsProvider).valueOrNull ?? const <Product>[];
      return ListView(padding: pagePadding, children: [
        for (final c in categories)
          ListRow(
            title: c.name,
            subtitle: '${products.where((p) => p.categoryId == c.id).length} món',
            onTap: isManager ? () => onEdit(c) : null,
            trailing: !isManager
                ? null
                : IconButton(
                    tooltip: 'Xóa danh mục',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final yes = await confirmDialog(context,
                          title: 'Xóa danh mục ${c.name}?', confirm: 'Xóa', destructive: true);
                      if (!yes) return;
                      final ok = await ref.read(menuControllerProvider.notifier).deleteCategory(c.id);
                      if (!ok) onError();
                    },
                  ),
          ),
      ]);
    });
  }
}

