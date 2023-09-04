import 'package:flutter/material.dart';
import 'package:wow_shopping/features/login/login_page_wrapper.dart';

import '../../app/theme.dart';
import '../../widgets/top_nav_bar.dart';
import 'widgets/time_out_widget.dart';

import '../../../app/assets.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/common.dart';
import '../main/main_screen.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen._({super.key, this.email});
  // final Function(String? code) onContinue;
  final String? email;

  static Route<void> route(String? email) {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: VerifyScreen._(email: email),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _codeController = TextEditingController();

    void onContinue() {
      Navigator.of(context).pushReplacement(MainScreen.route());
    }

    final appTheme = AppTheme.of(context);
    return Material(
      color: appTheme.appBarColor,
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets, //! How expensive is this?

          child: Column(
            children: [
              const TopNavBar(
                title: Padding(
                  padding: verticalPadding8,
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              verticalMargin48,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text.rich(
                          TextSpan(
                            text: 'Please enter the verification code sent to ',
                            style: const TextStyle(fontSize: 16),
                            children: [
                              TextSpan(
                                text: email,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalMargin48,
                      TextFormField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          hintText: 'Code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      verticalMargin24,
                      AppButton(
                        label: 'Done',
                        style: AppButtonStyle.highlighted,
                        iconAsset: Assets.iconContinue,
                        onPressed: onContinue,
                        labelAlignment: TextAlign.center,
                      ),
                      verticalMargin24,
                      const TimeOutWidget(duration: Duration(seconds: 20)),
                      verticalMargin48,
                    ],
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
