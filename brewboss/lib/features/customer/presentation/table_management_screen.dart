import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../pos/application/pos_providers.dart';
import '../../pos/presentation/receipt.dart' show pdfTheme;

/// Public address of the customer web build, encoded in table QR codes.
String tableQrUrl(String tableId) {
  const configured = String.fromEnvironment('CUSTOMER_BASE_URL', defaultValue: 'https://brewboss-prm393.web.app');
  final base = kIsWeb ? Uri.base.origin : configured;
  return '$base${Routes.customerMenu(tableId)}';
}

Future<Uint8List> _qrPdf(List<CafeTable> tables) async {
  final doc = pw.Document(theme: await pdfTheme());
  doc.addPage(pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (_) => pw.Wrap(spacing: 24, runSpacing: 24, children: [
      for (final t in tables)
        pw.Column(children: [
          pw.Text('Bàn ${t.name}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.SizedBox(height: 6),
          pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: tableQrUrl(t.id), width: 140, height: 140),
          pw.SizedBox(height: 4),
          pw.Text('Quét để gọi món', style: const pw.TextStyle(fontSize: 10)),
        ]),
    ]),
  ));
  return doc.save();
}

Future<void> _printQr(List<CafeTable> tables, String name) =>
    Printing.layoutPdf(onLayout: (_) => _qrPdf(tables), name: name);

class TableManagementScreen extends ConsumerWidget {
  const TableManagementScreen({super.key});

  void _showQr(BuildContext context, CafeTable t) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Mã QR bàn ${t.name}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 19)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(width: 200, height: 200, child: QrImageView(data: tableQrUrl(t.id))),
          const SizedBox(height: 12),
          const Text('Khách quét mã để xem thực đơn và gọi món', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
        ]),
        actions: [
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng'))),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () => _printQr([t], 'QR_${t.name}'),
                child: const Text('In / Chia sẻ', overflow: TextOverflow.ellipsis),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(tablesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý bàn'),
        actions: [
          IconButton(
            tooltip: 'In tất cả mã QR',
            icon: const Icon(Icons.print_outlined),
            onPressed: value.valueOrNull?.isNotEmpty == true ? () => _printQr(value.requireValue, 'QR_tat_ca') : null,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Thêm bàn',
        onPressed: () => showAppSheet<void>(context, (_) => const _TableForm()),
        child: const Icon(Icons.add),
      ),
      body: AsyncBody(value, retry: tablesProvider, builder: (tables) {
        if (tables.isEmpty) return const EmptyView('Chưa có bàn nào');
        final areas = tables.map((t) => t.area).toSet();
        return ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 88), children: [
          for (final area in areas) ...[
            SectionLabel(area.toUpperCase()),
            for (final t in tables.where((t) => t.area == area))
              ListRow(
                title: t.name,
                subtitle: '${t.capacity} chỗ',
                onTap: () => showAppSheet<void>(context, (_) => _TableForm(table: t)),
                trailing: OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size(56, 40)),
                  onPressed: () => _showQr(context, t),
                  child: const Text('QR', style: TextStyle(fontSize: 14)),
                ),
              ),
          ],
        ]);
      }),
    );
  }
}

class _TableForm extends ConsumerStatefulWidget {
  const _TableForm({this.table});
  final CafeTable? table;
  @override
  ConsumerState<_TableForm> createState() => _TableFormState();
}

class _TableFormState extends ConsumerState<_TableForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.table?.name);
  late final _area = TextEditingController(text: widget.table?.area);
  late final _capacity = TextEditingController(text: widget.table == null ? '' : '${widget.table!.capacity}');
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showMessage(context, ErrorMapper.message(e));
      }
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _run(() => ref.read(tableRepositoryProvider).save(CafeTable(
          id: widget.table?.id ?? '',
          name: _name.text.trim(),
          area: _area.text.trim(),
          capacity: parseMoney(_capacity.text)!,
        )));
  }

  Future<void> _delete() async {
    final yes = await confirmDialog(context, title: 'Xóa bàn ${widget.table!.name}?', confirm: 'Xóa', destructive: true);
    if (yes) _run(() => ref.read(tableRepositoryProvider).delete(widget.table!));
  }

  String? _validateName(String? v) {
    final required = validateRequired(v);
    if (required != null) return required;
    final name = foldAccents(v!.trim());
    final tables = ref.read(tablesProvider).valueOrNull ?? const <CafeTable>[];
    return tables.any((t) => t.id != widget.table?.id && foldAccents(t.name) == name) ? 'Tên bàn đã tồn tại' : null;
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          SheetTitle(widget.table == null ? 'Thêm bàn' : 'Sửa bàn'),
          LabeledField(label: 'Tên bàn *', child: TextFormField(controller: _name, validator: _validateName)),
          LabeledField(label: 'Khu vực *', child: TextFormField(controller: _area, validator: validateRequired)),
          LabeledField(
            label: 'Số chỗ *',
            child: TextFormField(
              controller: _capacity,
              keyboardType: TextInputType.number,
              validator: (v) => (parseMoney(v) ?? 0) > 0 ? null : 'Số chỗ phải lớn hơn 0',
            ),
          ),
          FilledButton(onPressed: _busy ? null : _save, child: const Text('Lưu')),
          if (widget.table != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: _busy ? null : _delete, child: const Text('Xóa bàn')),
          ],
        ]),
      );
}
