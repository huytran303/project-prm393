import '../../../models/models.dart';

/// Message code of why the voucher cannot be used, or null when valid.
String? voucherError(Voucher? v, int subtotal, DateTime now) {
  if (v == null || !v.isActive) return 'MSG22';
  if (v.expiresAt != null && v.expiresAt!.isBefore(now)) return 'MSG23';
  if (v.usedCount >= v.usageLimit) return 'MSG24';
  if (subtotal < v.minOrder) return 'MSG25';
  return null;
}

/// Percent capped by maxDiscount, or fixed; never above the subtotal (BR-DIS-02).
int voucherDiscount(Voucher v, int subtotal) {
  var discount = v.type == VoucherType.percent ? subtotal * v.value ~/ 100 : v.value;
  if (v.type == VoucherType.percent && v.maxDiscount != null && discount > v.maxDiscount!) {
    discount = v.maxDiscount!;
  }
  return discount > subtotal ? subtotal : discount;
}

int pointsEarned(int total, int pointsPerVnd) => total ~/ pointsPerVnd;

/// min(balance, whole points the remaining amount can absorb) (BR-LOY-02).
int maxRedeemable(int balance, int totalBeforePoints, int vndPerPoint) {
  final byAmount = totalBeforePoints ~/ vndPerPoint;
  return balance < byAmount ? balance : byAmount;
}

/// Digits only with a leading 0; "+84" and "84" prefixes are converted.
String normalizePhone(String raw) {
  var digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('84') && digits.length == 11) digits = '0${digits.substring(2)}';
  return digits;
}
