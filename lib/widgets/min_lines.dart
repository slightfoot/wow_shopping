import 'package:flutter/material.dart';

class MinLines extends StatelessWidget {
  const MinLines({
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.alignment = AlignmentDirectional.topStart,
    required this.minLines,
    required this.child,
  });

  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final int minLines;
  final AlignmentGeometry alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = style;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle!.merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final painter = TextPainter(
      text: TextSpan(style: effectiveTextStyle, text: 'M'),
      textDirection: Directionality.of(context),
      locale: Localizations.localeOf(context),
      textScaleFactor: MediaQuery.textScaleFactorOf(context),
      textWidthBasis: defaultTextStyle.textWidthBasis,
      textHeightBehavior:
          defaultTextStyle.textHeightBehavior ?? DefaultTextHeightBehavior.maybeOf(context),
    );
    painter.layout();
    final metrics = painter.computeLineMetrics();
    return SizedBox(
      height: metrics.first.height * minLines,
      child: Align(
        alignment: alignment,
        child: DefaultTextStyle.merge(
          style: style,
          overflow: overflow,
          maxLines: maxLines,
          child: child,
        ),
      ),
    );
  }
}
