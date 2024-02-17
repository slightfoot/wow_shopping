import 'package:flutter/material.dart';
import 'package:wow_shopping/widgets/common.dart';

@immutable
class ContentHeading extends StatelessWidget {
  const ContentHeading({
    super.key,
    required this.title,
    this.buttonLabel,
    this.onButtonPressed,
  });

  final String title;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        horizontalMargin8,
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
        ),
        if (buttonLabel case final buttonLabel?) //
          TextButton(
            onPressed: onButtonPressed,
            style: TextButton.styleFrom(
              padding: horizontalPadding8,
            ),
            child: Text(buttonLabel),
          )
        else
          horizontalMargin8,
      ],
    );
  }
}
