final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
final _phonePattern = RegExp(r'^0\d{9}$');

String? validateRequired(String? v, [String message = 'Không được để trống']) =>
    v == null || v.trim().isEmpty ? message : null;

String? validateEmail(String? v) =>
    v != null && _emailPattern.hasMatch(v.trim()) ? null : 'Email không hợp lệ';

String? validatePhone(String? v) => v != null && _phonePattern.hasMatch(v.replaceAll(' ', ''))
    ? null
    : 'Số điện thoại gồm 10 chữ số, bắt đầu bằng 0';

/// Reads a money input such as "500.000" as an integer VND amount.
int? parseMoney(String? v) {
  final digits = (v ?? '').replaceAll(RegExp(r'[.,\s]'), '');
  return digits.isEmpty ? null : int.tryParse(digits);
}

String? validateMoney(String? v) {
  final amount = parseMoney(v);
  return amount == null || amount < 0 ? 'Số tiền không hợp lệ' : null;
}

/// Reads a stock quantity, accepting both "." and "," as the decimal mark.
num? parseQty(String? v) {
  final text = (v ?? '').trim().replaceAll(',', '.');
  return text.isEmpty ? null : num.tryParse(text);
}
