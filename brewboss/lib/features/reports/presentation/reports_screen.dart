import 'package:excel/excel.dart' as xl;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme.dart';
import '../../../core/utils/date_range.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pos/presentation/receipt.dart' show pdfTheme;
import '../../staff/presentation/shift_history_screen.dart' show pickRange;
import '../application/report_providers.dart';
import '../application/report_rules.dart';

enum ExportFormat { pdf, excel }

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  late ReportQuery _query = ReportQuery(Bucket.day, _defaultRange(Bucket.day));

  /// Default period per grouping: 7 days, 4 weeks or 6 months up to today.
  DateRange _defaultRange(Bucket b) {
    final end = DateRange.today().to;
    return DateRange(switch (b) {
      Bucket.day => DateTime(end.year, end.month, end.day - 7),
      Bucket.week => DateTime(end.year, end.month, end.day - 28),
      Bucket.month => DateTime(end.year, end.month - 6, end.day),
    }, end);
  }

  void _shift(int direction) {
    final r = _query.range;
    final days = r.to.difference(r.from).inDays * direction;
    DateTime move(DateTime d) => DateTime(d.year, d.month, d.day + days);
    setState(() => _query = ReportQuery(_query.bucket, DateRange(move(r.from), move(r.to))));
  }

  Future<void> _export(ExportFormat f, Report report) async {
    final r = _query.range;
    final stamp = '${formatDate(r.from).replaceAll('/', '')}_${formatDate(r.lastDay).replaceAll('/', '')}';
    final top = topProducts(report.orders, 10);
    final split = paymentSplit(report.orders);
    if (f == ExportFormat.pdf) {
      final doc = pw.Document(theme: await pdfTheme());
      doc.addPage(pw.MultiPage(
        build: (_) => [
          pw.Header(level: 0, text: 'Báo cáo ${formatDate(r.from)} – ${formatDate(r.lastDay)}'),
          pw.Text('Doanh thu: ${formatVnd(report.totals.revenue)} · Số đơn: ${report.totals.count}'),
          pw.Text('Tiền mặt: ${formatVnd(split.$1)} · Chuyển khoản: ${formatVnd(split.$2)}'),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
              headers: const ['Kỳ', 'Từ ngày', 'Doanh thu'],
              data: [for (final p in report.points) [p.label, formatDate(p.from), formatVnd(p.revenue)]]),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
              headers: const ['Món bán chạy', 'Số lượng'], data: [for (final (n, q) in top) [n, '$q']]),
        ],
      ));
      await Printing.sharePdf(bytes: await doc.save(), filename: 'BaoCao_$stamp.pdf');
      return;
    }
    final book = xl.Excel.createExcel();
    final sheet = book[book.getDefaultSheet()!];
    xl.TextCellValue t(String s) => xl.TextCellValue(s);
    xl.IntCellValue n(int v) => xl.IntCellValue(v);
    sheet.appendRow([t('Từ ngày'), t('Kỳ'), t('Doanh thu')]);
    for (final p in report.points) {
      sheet.appendRow([t(formatDate(p.from)), t(p.label), n(p.revenue)]);
    }
    sheet.appendRow([t('Tổng'), n(report.totals.count), n(report.totals.revenue)]);
    sheet.appendRow([t('Tiền mặt'), n(split.$1), t('Chuyển khoản'), n(split.$2)]);
    sheet.appendRow([t('Món bán chạy'), t('Số lượng')]);
    for (final (name, qty) in top) {
      sheet.appendRow([t(name), n(qty)]);
    }
    final bytes = Uint8List.fromList(book.encode()!);
    await SharePlus.instance.share(ShareParams(files: [
      XFile.fromData(bytes,
          name: 'BaoCao_$stamp.xlsx',
          mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
    ], fileNameOverrides: ['BaoCao_$stamp.xlsx']));
  }

  @override
  Widget build(BuildContext context) {
    final provider = reportProvider(_query);
    final value = ref.watch(provider);
    final r = _query.range;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo'),
        actions: [
          PopupMenuButton<ExportFormat>(
            enabled: (value.valueOrNull?.orders.isNotEmpty) ?? false,
            onSelected: (f) => _export(f, value.requireValue),
            itemBuilder: (_) => const [
              PopupMenuItem(value: ExportFormat.pdf, child: Text('PDF')),
              PopupMenuItem(value: ExportFormat.excel, child: Text('Excel')),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Text('Xuất', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),
                Icon(Icons.arrow_drop_down),
              ]),
            ),
          ),
        ],
      ),
      body: ListView(padding: pagePadding, children: [
        SegmentBar<Bucket>(
          options: const {Bucket.day: 'Ngày', Bucket.week: 'Tuần', Bucket.month: 'Tháng'},
          selected: _query.bucket,
          onSelected: (b) => setState(() => _query = ReportQuery(b, _defaultRange(b))),
        ),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(tooltip: 'Kỳ trước', icon: const Icon(Icons.chevron_left), onPressed: () => _shift(-1)),
          InkWell(
            onTap: () async {
              final picked = await pickRange(context, r);
              if (picked != null) setState(() => _query = ReportQuery(_query.bucket, picked));
            },
            child: Text('${formatDayMonth(r.from)} – ${formatDate(r.lastDay)}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          IconButton(tooltip: 'Kỳ sau', icon: const Icon(Icons.chevron_right), onPressed: () => _shift(1)),
        ]),
        AsyncBody(value, retry: provider, builder: (report) {
          final split = paymentSplit(report.orders);
          final top = topProducts(report.orders, 10);
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(child: _Card('Doanh thu', formatVnd(report.totals.revenue))),
              const SizedBox(width: 10),
              Expanded(child: _Card('Số đơn', '${report.totals.count}')),
            ]),
            const SizedBox(height: 14),
            if (report.orders.isEmpty)
              const EmptyView('Không có đơn đã thanh toán trong kỳ này')
            else ...[
              SizedBox(height: 170, child: _RevenueChart(points: report.points)),
              const SectionLabel('MÓN BÁN CHẠY'),
              OutlineCard(
                child: Column(children: [
                  for (final (i, (name, qty)) in top.indexed)
                    InfoRow('${i + 1}  $name', '$qty ly', bold: true),
                ]),
              ),
              const SectionLabel('THEO PHƯƠNG THỨC THANH TOÁN'),
              _SplitBar(cash: split.$1, qr: split.$2),
            ],
          ]);
        }),
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => OutlineCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          FittedBox(child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
        ]),
      );
}

class _RevenueChart extends StatelessWidget {
  const _RevenueChart({required this.points});
  final List<Point> points;

  @override
  Widget build(BuildContext context) => BarChart(BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(
            show: true, border: const Border(bottom: BorderSide(color: AppColors.border))),
        barTouchData: BarTouchData(
          touchCallback: (event, response) {
            final spot = response?.spot;
            if (event is FlTapUpEvent && spot != null) {
              final p = points[spot.touchedBarGroupIndex];
              context.push('${Routes.orders}?from=${p.from.toIso8601String()}&to=${p.to.toIso8601String()}');
            }
          },
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, _, rod, _) =>
                BarTooltipItem(formatVnd(rod.toY.round()), const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (v, meta) => SideTitleWidget(
                meta: meta,
                child: Text(points[v.toInt()].label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ),
            ),
          ),
        ),
        barGroups: [
          for (final (i, p) in points.indexed)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: p.revenue.toDouble(),
                color: AppColors.ink,
                width: points.length > 12 ? 8 : 26,
                borderRadius: BorderRadius.zero,
              ),
            ]),
        ],
      ));
}

class _SplitBar extends StatelessWidget {
  const _SplitBar({required this.cash, required this.qr});
  final int cash;
  final int qr;
  @override
  Widget build(BuildContext context) {
    final total = cash + qr;
    final cashPercent = total == 0 ? 0 : (cash * 100 / total).round();
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Row(children: [
          if (cash > 0) Expanded(flex: cash, child: Container(height: 14, color: AppColors.ink)),
          if (qr > 0) Expanded(flex: qr, child: Container(height: 14, color: AppColors.disabled)),
          if (total == 0) Expanded(child: Container(height: 14, color: AppColors.fill)),
        ]),
      ),
      const SizedBox(height: 6),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Tiền mặt $cashPercent%', style: const TextStyle(fontSize: 13)),
        Text('Chuyển khoản ${total == 0 ? 0 : 100 - cashPercent}%', style: const TextStyle(fontSize: 13)),
      ]),
    ]);
  }
}
