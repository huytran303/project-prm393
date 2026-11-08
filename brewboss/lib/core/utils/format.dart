import 'package:intl/intl.dart';

final _thousands = NumberFormat('#,###', 'vi_VN');

/// Digits only: "45.000" (used in money fields and presets).
String formatNumber(num value) => _thousands.format(value);

/// "45.000 ₫" (NFR-USE-03).
String formatVnd(int value) => '${formatNumber(value)} ₫';

/// Stock quantities: no trailing decimals, thousands grouped.
String formatQty(num value) {
  if (value == value.roundToDouble()) return formatNumber(value.round());
  return NumberFormat('#,##0.##', 'vi_VN').format(value);
}

String formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);
String formatDayMonth(DateTime d) => DateFormat('dd/MM').format(d);
String formatTime(DateTime d) => DateFormat('HH:mm').format(d);
String formatDayTime(DateTime d) => DateFormat('dd/MM HH:mm').format(d);

/// "Thứ Tư, 23/09/2026"
String formatWeekdayDate(DateTime d) {
  const days = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
  return '${days[d.weekday - 1]}, ${formatDate(d)}';
}

/// "02:39:12"
String formatClock(Duration d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
}

/// "8,1 giờ"
String formatHours(Duration d) => '${NumberFormat('0.0', 'vi_VN').format(d.inMinutes / 60)} giờ';

/// "0912 345 678"
String formatPhone(String p) =>
    p.length == 10 ? '${p.substring(0, 4)} ${p.substring(4, 7)} ${p.substring(7)}' : p;

/// Lower-cased with Vietnamese accents removed, for search (UC10).
String foldAccents(String input) {
  const groups = {
    'a': 'àáạảãâầấậẩẫăằắặẳẵ',
    'e': 'èéẹẻẽêềếệểễ',
    'i': 'ìíịỉĩ',
    'o': 'òóọỏõôồốộổỗơờớợởỡ',
    'u': 'ùúụủũưừứựửữ',
    'y': 'ỳýỵỷỹ',
    'd': 'đ',
  };
  var out = input.toLowerCase();
  groups.forEach((base, accents) {
    for (final c in accents.split('')) {
      out = out.replaceAll(c, base);
    }
  });
  return out;
}
