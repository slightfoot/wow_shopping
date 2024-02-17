import 'package:flutter/widgets.dart';

typedef ChildBuilderFn = Widget Function(BuildContext context, Widget child);

class ChildBuilder extends StatelessWidget {
  const ChildBuilder({
    super.key,
    required this.builder,
    required this.child,
  });

  final ChildBuilderFn builder;
  final Widget child;

  @override
  Widget build(BuildContext context) => builder(context, child);
}
