import 'package:flutter/material.dart';

import '../../../app/assets.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/common.dart';
import 'gender_selection.dart';

class GenderSelectionView extends StatelessWidget {
  const GenderSelectionView({
    super.key,
    required this.onContinue,
  });

  final Function(String?) onContinue;

  @override
  Widget build(BuildContext context) {
    String? selectedGender;

    return Column(
      children: [
        const Text('Welcome Back,', style: TextStyle(fontSize: 30)),
        verticalMargin16,
        const Text('login to continue', style: TextStyle(fontSize: 16)),
        const Spacer(),
        GenderSelection(selectedValue: (value) => selectedGender = value),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Create account',
              style: AppButtonStyle.highlighted,
              iconAsset: Assets.iconContinue,
              onPressed: () => onContinue(selectedGender),
              labelAlignment: TextAlign.center,
            ),
          ),
        ),
        verticalMargin48,
      ],
    );
  }
}
