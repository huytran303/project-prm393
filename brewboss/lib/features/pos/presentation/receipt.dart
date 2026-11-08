import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';

Future<pw.ThemeData> pdfTheme() async => pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf')),
      bold: pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf')),
    );

Future<Uint8List> buildReceiptPdf(Order o, ShopSettings shop, String place, {int? change}) async {
  final doc = pw.Document(theme: await pdfTheme());
  final bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);
  pw.Widget row(String l, String r, {pw.TextStyle? style}) => pw.Row(children: [
        pw.Expanded(child: pw.Text(l, style: style)),
        pw.Text(r, style: style),
      ]);
  doc.addPage(pw.Page(
    pageFormat: PdfPageFormat.roll80,
    build: (_) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
      pw.Text(shop.name, textAlign: pw.TextAlign.center, style: bold.copyWith(fontSize: 14)),
      pw.Text(shop.address, textAlign: pw.TextAlign.center),
      pw.SizedBox(height: 6),
      pw.Text('Hóa đơn ${o.code} · $place', textAlign: pw.TextAlign.center),
      if (o.paidAt != null)
        pw.Text('${formatDate(o.paidAt!)} ${formatTime(o.paidAt!)}', textAlign: pw.TextAlign.center),
      pw.Divider(),
      for (final i in o.items) row(i.label, formatVnd(i.lineTotal)),
      pw.Divider(),
      row('Tạm tính', formatVnd(o.subtotal)),
      if (o.discount > 0) row('Voucher (${o.voucherCode})', '-${formatVnd(o.discount)}'),
      if (o.pointsRedeemed > 0) row('Đổi ${o.pointsRedeemed} điểm', '-${formatVnd(o.subtotal - o.discount - o.total)}'),
      row('Tổng cộng', formatVnd(o.total), style: bold),
      if (o.cashAmount > 0) row('Tiền mặt', formatVnd(o.cashAmount)),
      if (o.qrAmount > 0) row('Chuyển khoản', formatVnd(o.qrAmount)),
      if (change != null && change > 0) row('Tiền thừa', formatVnd(change)),
      pw.SizedBox(height: 8),
      pw.Text('Cảm ơn quý khách!', textAlign: pw.TextAlign.center),
    ]),
  ));
  return doc.save();
}

/// Receipt preview with share and print (UC28). Change exists only right after
/// payment because it is not stored (BR-PAY-02).
Future<void> showReceipt(BuildContext context, Order o, ShopSettings shop, String place, {int? change}) =>
    showAppSheet<void>(context, (ctx) {
      Future<Uint8List> pdf() => buildReceiptPdf(o, shop, place, change: change);
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        SheetTitle('Hóa đơn ${o.code}'),
        OutlineCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(shop.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(shop.address, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
            Text(place, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
            const Divider(height: 16),
            for (final i in o.items) InfoRow(i.label, formatVnd(i.lineTotal)),
            const Divider(height: 16),
            InfoRow('Tạm tính', formatVnd(o.subtotal)),
            if (o.discount > 0) InfoRow('Voucher (${o.voucherCode})', '−${formatVnd(o.discount)}'),
            if (o.pointsRedeemed > 0)
              InfoRow('Đổi ${o.pointsRedeemed} điểm', '−${formatVnd(o.subtotal - o.discount - o.total)}'),
            InfoRow('Tổng cộng', formatVnd(o.total), bold: true),
            if (o.cashAmount > 0) InfoRow('Tiền mặt', formatVnd(o.cashAmount)),
            if (o.qrAmount > 0) InfoRow('Chuyển khoản', formatVnd(o.qrAmount)),
            if (change != null && change > 0) InfoRow('Tiền thừa', formatVnd(change)),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () async => Printing.sharePdf(bytes: await pdf(), filename: 'Receipt_${o.code}.pdf'),
              child: const Text('Chia sẻ'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton(
              onPressed: () => Printing.layoutPdf(onLayout: (_) => pdf(), name: 'Receipt_${o.code}'),
              child: const Text('In'),
            ),
          ),
        ]),
      ]);
    });
