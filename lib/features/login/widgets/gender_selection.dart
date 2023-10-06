import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/assets.dart';
import '../../../widgets/common.dart';

class GenderSelection extends StatefulWidget {
  const GenderSelection({
    super.key,
    required this.selectedValue,
  });

  final Function(String? value) selectedValue;
  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  final genders = ['Male', 'Female'];

  String? _selected = 'Male';

  void onTap(String? value) {
    setState(() => _selected = value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Select your gender',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        verticalMargin24,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenderOption(
              text: 'Male',
              isSelected: _selected == 'Male',
              onPressed: onTap,
            ),
            horizontalMargin16,
            GenderOption(
              text: 'Female',
              isSelected: _selected == 'Female',
              onPressed: onTap,
            ),
          ],
        ),
      ],
    );
  }
}

class GenderOption extends StatelessWidget {
  const GenderOption({
    super.key,
    required this.text,
    required this.isSelected,
    this.onPressed,
  });

  final String text;
  final bool isSelected;
  final Function(String value)? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => onPressed?.call(text),
          child: Stack(
            children: [
              if (isSelected)
                Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(
                    Assets.iconCheckFilled,
                    height: 24,
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
