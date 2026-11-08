import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../application/customer_providers.dart';

/// S18: live progress; follows mergedIntoId after a QR add-on (UC33).
class CustomerOrderStatusScreen extends ConsumerWidget {
  const CustomerOrderStatusScreen({super.key, required this.tableId, required this.orderId});
  final String tableId;
  final String orderId;

  static const _steps = ['Chờ xác nhận', 'Đã nhận', 'Đang pha', 'Sẵn sàng'];

  int _step(OrderStatus s) => switch (s) {
        OrderStatus.awaiting => 0,
        OrderStatus.pending => 1,
        OrderStatus.preparing => 2,
        _ => 3,
      };

  String _headline(OrderStatus s) => switch (s) {
        OrderStatus.awaiting => 'Đang chờ nhân viên xác nhận',
        OrderStatus.pending => 'Quán đã nhận đơn của bạn',
        OrderStatus.preparing => 'Đồ uống đang được pha',
        OrderStatus.ready => 'Đồ uống đã sẵn sàng',
        OrderStatus.served => 'Đã phục vụ, chúc bạn ngon miệng',
        OrderStatus.paid => 'Đã thanh toán, cảm ơn bạn',
        OrderStatus.cancelled => 'Đơn đã bị hủy',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracked = trackedOrderProvider(orderId);
    final tableName = ref.watch(customerTableProvider(tableId)).valueOrNull?.name ?? '';
    final value = ref.watch(tracked);
    final code = value.valueOrNull?.order.shortId;
    return Scaffold(
      appBar: AppBar(title: Text(code == null ? 'Đơn của bạn' : 'Đơn của bạn · $code')),
      body: AsyncBody(value, retry: tracked, builder: (t) {
        final o = t.order;
        final at = o.createdAt;
        return ListView(padding: pagePadding, children: [
          if (t.merged)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(msg('MSG21', {'shortId': o.code}), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          if (o.status == OrderStatus.cancelled)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DashedBox(
                color: AppColors.red,
                child: Text(msg('MSG39'), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.red)),
              ),
            ),
          OutlineCard(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('☕', style: TextStyle(fontSize: 38)),
              const SizedBox(height: 8),
              Text(_headline(o.status), textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Bàn $tableName${at == null ? '' : ' · đặt lúc ${formatTime(at)}'}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 16),
          if (o.status != OrderStatus.cancelled) _Progress(current: _step(o.status), labels: _steps),
          const SectionLabel('CHI TIẾT'),
          OutlineCard(
            child: Column(children: [
              for (final i in o.items) InfoRow(i.label, formatVnd(i.lineTotal)),
              InfoRow('Tổng', formatVnd(o.total), bold: true),
            ]),
          ),
          const SizedBox(height: 16),
          const Text('Vui lòng thanh toán tại quầy.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 10),
          const Text('Muốn gọi thêm món? Vui lòng gọi nhân viên.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
        ]);
      }),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.current, required this.labels});
  final int current;
  final List<String> labels;

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final (i, label) in labels.indexed)
          Expanded(
            child: Column(children: [
              Row(children: [
                Expanded(child: Container(height: 2, color: i == 0 ? Colors.transparent : AppColors.border)),
                _Dot(index: i, current: current),
                Expanded(child: Container(height: 2, color: i == labels.length - 1 ? Colors.transparent : AppColors.border)),
              ]),
              const SizedBox(height: 6),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, fontWeight: i == current ? FontWeight.w700 : null)),
            ]),
          ),
      ]);
}

class _Dot extends StatelessWidget {
  const _Dot({required this.index, required this.current});
  final int index;
  final int current;
  @override
  Widget build(BuildContext context) {
    final done = index < current;
    final active = index == current;
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? AppColors.ink : Colors.white,
        border: Border.all(color: done || active ? AppColors.ink : AppColors.border, width: active ? 2 : 1),
      ),
      child: done
          ? const Icon(Icons.check, color: Colors.white, size: 18)
          : Text('${index + 1}', style: TextStyle(color: active ? AppColors.text : AppColors.muted)),
    );
  }
}
