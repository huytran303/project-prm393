import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase_providers.dart';
import '../theme.dart';
import '../utils/error_mapper.dart';
import '../utils/format.dart';
import '../utils/messages.dart';
import '../utils/validators.dart';

const pagePadding = EdgeInsets.all(16);

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator());
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.error, required this.onRetry});
  final Object? error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: pagePadding,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(ErrorMapper.message(error), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
          ]),
        ),
      );
}

class EmptyView extends StatelessWidget {
  const EmptyView(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: pagePadding,
          child: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
        ),
      );
}

/// Loading / error-with-retry / data rendering required on every screen (SRS 5.2).
class AsyncBody<T> extends ConsumerWidget {
  const AsyncBody(this.value, {super.key, required this.retry, required this.builder});
  final AsyncValue<T> value;
  final ProviderOrFamily retry;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) => value.when(
        skipLoadingOnReload: true,
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(retry)),
        data: builder,
      );
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

Future<bool> confirmDialog(BuildContext context,
    {required String title, String? message, String confirm = 'Xác nhận', bool destructive = false}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
        FilledButton(
          style: destructive ? FilledButton.styleFrom(backgroundColor: AppColors.red) : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirm),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Text prompt returning the entered reason, or null when dismissed.
Future<String?> reasonDialog(BuildContext context,
    {required String title, required String emptyError, String label = 'Lý do', String confirm = 'Xác nhận'}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            maxLength: 200,
            decoration: InputDecoration(hintText: label),
            validator: (v) => validateRequired(v, emptyError),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(ctx, controller.text.trim());
            },
            child: Text(confirm),
          ),
        ],
      );
    },
  );
}

/// "Mất kết nối" while cached data stays visible (MSG18).
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(offlineProvider).valueOrNull != true) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: AppColors.red,
      padding: const EdgeInsets.all(6),
      child: Text(msg('MSG18'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
    );
  }
}

/// Grey upper-case section heading such as "CHỨC NĂNG".
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Row(children: [
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.muted)),
          ),
          ?trailing,
        ]),
      );
}

/// Small caption above an outlined field, as drawn in the mock-ups.
class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          const SizedBox(height: 4),
          child,
        ]),
      );
}

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.hint, required this.onChanged});
  final String hint;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search, color: AppColors.muted),
        ),
      );
}

/// Horizontally scrolling pill filter ("Tất cả", "Cà phê", ...).
class PillFilter<T> extends StatelessWidget {
  const PillFilter({super.key, required this.options, required this.selected, required this.onSelected});
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onSelected;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final e in options.entries)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Pill(label: e.value, selected: e.key == selected, onTap: () => onSelected(e.key)),
              ),
          ],
        ),
      );
}

class Pill extends StatelessWidget {
  const Pill({super.key, required this.label, this.selected = false, this.onTap});
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          // No alignment here: it would stretch the pill to full width inside a Wrap.
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.ink : Colors.white,
            border: Border.all(color: selected ? AppColors.ink : AppColors.border),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.text)),
        ),
      );
}

/// Connected segment control with a dark selected part ("Ngày | Tuần | Tháng").
class SegmentBar<T> extends StatelessWidget {
  const SegmentBar({super.key, required this.options, required this.selected, required this.onSelected});
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onSelected;
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.ink),
          borderRadius: BorderRadius.circular(_segmentRadius),
        ),
        child: Row(children: [
          for (final e in options.entries)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(_segmentRadius),
                onTap: () => onSelected(e.key),
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: e.key == selected ? AppColors.ink : null,
                    borderRadius: BorderRadius.circular(_segmentRadius),
                  ),
                  child: Text(e.value, style: TextStyle(color: e.key == selected ? Colors.white : AppColors.text)),
                ),
              ),
            ),
        ]),
      );
}

const _segmentRadius = 10.0;

enum BadgeStyle { dark, light, red }

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.text, {super.key, this.style = BadgeStyle.light});
  final String text;
  final BadgeStyle style;
  @override
  Widget build(BuildContext context) {
    final (bg, fg, line) = switch (style) {
      BadgeStyle.dark => (AppColors.ink, Colors.white, AppColors.ink),
      BadgeStyle.light => (AppColors.fill, AppColors.text, AppColors.fill),
      BadgeStyle.red => (Colors.white, AppColors.red, AppColors.red),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, border: Border.all(color: line), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 13)),
    );
  }
}

class InitialAvatar extends StatelessWidget {
  const InitialAvatar(this.name, {super.key, this.size = 44, this.onTap});
  final String name;
  final double size;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(' ');
    final letter = name.trim().isEmpty ? '?' : parts.last.characters.first.toUpperCase();
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppColors.fill, border: Border.all(color: AppColors.border)),
        child: Text(letter,
            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.muted, fontSize: size * 0.36)),
      ),
    );
  }
}

/// Crossed grey box of the wireframes, also shown when a product has no image.
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: AppColors.fill, border: Border.all(color: AppColors.border)),
        child: CustomPaint(painter: _CrossPainter(), child: const SizedBox.expand()),
      );
}

class _CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(_CrossPainter oldDelegate) => false;
}

class ProductImage extends StatelessWidget {
  const ProductImage(this.url, {super.key});
  final String? url;
  @override
  Widget build(BuildContext context) => url == null || url!.isEmpty
      ? const ImagePlaceholder()
      : CachedNetworkImage(
          imageUrl: url!,
          fit: BoxFit.cover,
          memCacheWidth: 400,
          placeholder: (_, _) => const ImagePlaceholder(),
          errorWidget: (_, _, _) => const ImagePlaceholder(),
        );
}

/// Outlined rounded card used across the mock-ups.
class OutlineCard extends StatelessWidget {
  const OutlineCard({super.key, required this.child, this.padding = const EdgeInsets.all(12), this.onTap, this.color});
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) => Material(
        color: color ?? Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
      );
}

/// Dashed border box used for warnings and awaiting states.
class DashedBox extends StatelessWidget {
  const DashedBox({super.key, required this.child, this.color = AppColors.ink, this.padding = const EdgeInsets.all(12)});
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _DashedPainter(color),
        child: Padding(padding: padding, child: child),
      );
}

class _DashedPainter extends CustomPainter {
  _DashedPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;
    final outline = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)));
    for (final metric in outline.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 8) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedPainter oldDelegate) => oldDelegate.color != color;
}

/// Label on the left, value on the right.
class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key, this.bold = false, this.color, this.size});
  final String label;
  final String value;
  final bool bold;
  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontWeight: bold ? FontWeight.w700 : null, color: color, fontSize: size);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Text(label, style: style)),
        const SizedBox(width: 12),
        Text(value, style: style),
      ]),
    );
  }
}

/// Bottom action area separated by a line ("Xác nhận thanh toán", ...).
class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.child, this.color});
  final Widget child;
  final Color? color;
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: color ?? Colors.white, border: const Border(top: BorderSide(color: AppColors.divider))),
        child: SafeArea(top: false, child: Padding(padding: pagePadding, child: child)),
      );
}

/// Formats input as "500.000" while typing; read it with [parseMoney].
class MoneyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return const TextEditingValue();
    final text = formatNumber(int.parse(digits));
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}

class MoneyField extends StatelessWidget {
  const MoneyField({super.key, required this.controller, this.validator, this.onChanged, this.hint});
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final String? hint;
  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [MoneyInputFormatter()],
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(hintText: hint),
      );
}

/// Bottom sheet with scrolling content that stays above the keyboard.
Future<T?> showAppSheet<T>(BuildContext context, WidgetBuilder builder) => showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.viewInsetsOf(ctx).bottom + 16),
        child: SingleChildScrollView(child: builder(ctx)),
      ),
    );

class SheetTitle extends StatelessWidget {
  const SheetTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
      );
}

/// Radius-free divider list row: title, subtitle, optional trailing.
class ListRow extends StatelessWidget {
  const ListRow({super.key, required this.title, this.subtitle, this.leading, this.trailing, this.onTap, this.dimmed = false});
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool dimmed;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
          child: Row(children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15, color: dimmed ? AppColors.muted : AppColors.text)),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(subtitle!, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                ],
              ]),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ]),
        ),
      );
}
