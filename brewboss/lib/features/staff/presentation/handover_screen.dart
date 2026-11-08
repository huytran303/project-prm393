import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../application/my_shift_controller.dart';
import '../application/staff_rules.dart';

/// S07 check-out with cash handover (UC44).
class HandoverScreen extends ConsumerStatefulWidget {
  const HandoverScreen({super.key, required this.shift});
  final Shift shift;
  @override
  ConsumerState<HandoverScreen> createState() => _HandoverScreenState();
}

class _HandoverScreenState extends ConsumerState<HandoverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _counted = TextEditingController();
  final _note = TextEditingController();
  late final Future<CashSummary> _summary =
      ref.read(myShiftControllerProvider.notifier).previewHandover(widget.shift);

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(myShiftControllerProvider.notifier)
        .checkOut(widget.shift.id, parseMoney(_counted.text), _note.text.trim());
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(myShiftControllerProvider).error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final s = widget.shift;
    return Scaffold(
      appBar: AppBar(title: const Text('Kết ca · Bàn giao tiền')),
      bottomNavigationBar: BottomBar(
        child: Row(children: [
          OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.red),
              onPressed: ref.watch(myShiftControllerProvider).isLoading ? null : _confirm,
              child: const Text('Xác nhận check-out'),
            ),
          ),
        ]),
      ),
      body: FutureBuilder(
        future: _summary,
        builder: (context, snap) {
          if (snap.hasError) return ErrorView(error: snap.error, onRetry: () => setState(() {}));
          final sum = snap.data;
          if (sum == null) return const LoadingView();
          final diff = parseMoney(_counted.text) == null ? null : cashDiff(parseMoney(_counted.text)!, sum.expected);
          return Form(
            key: _formKey,
            child: ListView(padding: pagePadding, children: [
              OutlineCard(
                child: Column(children: [
                  InfoRow('Ca làm',
                      '${formatTime(s.checkIn ?? now)} – ${formatTime(now)} · ${formatHours(shiftDuration(s, now))}'),
                  InfoRow('Tiền đầu ca', formatVnd(sum.opening)),
                  InfoRow('Tiền mặt bán được', formatVnd(sum.cashSales)),
                  InfoRow('Chuyển khoản (chỉ tham khảo)', formatVnd(sum.qrSales), color: AppColors.muted),
                  const Divider(height: 16),
                  InfoRow('Tiền mặt dự kiến', formatVnd(sum.expected), bold: true, size: 17),
                ]),
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'Tiền mặt đếm được',
                child: MoneyField(controller: _counted, validator: validateMoney, onChanged: (_) => setState(() {})),
              ),
              if (diff != null)
                InfoRow(
                  'Chênh lệch',
                  diff == 0 ? 'Khớp' : '${diff < 0 ? 'Thiếu' : 'Thừa'} ${formatVnd(diff.abs())}',
                  bold: true,
                  size: 17,
                  color: diff == 0 ? null : AppColors.red,
                ),
              const SizedBox(height: 8),
              LabeledField(
                label: 'Ghi chú (bắt buộc khi có chênh lệch)',
                child: TextFormField(
                  controller: _note,
                  maxLines: 3,
                  maxLength: 500,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) => diff != null && needsNote(diff) && (v == null || v.trim().isEmpty) ? msg('MSG43') : null,
                ),
              ),
              const Text('Sau khi kết ca, số tiền bàn giao không thể sửa.',
                  style: TextStyle(color: AppColors.muted, fontSize: 13)),
            ]),
          );
        },
      ),
    );
  }
}
