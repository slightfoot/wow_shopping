import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wow_shopping/features/login/login_page_wrapper.dart';
import 'package:wow_shopping/features/login/login_verify_screen.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

import '../../../app/assets.dart';

class LoginToYourAccountWidget extends StatelessWidget {
  const LoginToYourAccountWidget._({super.key});

  static Route<void> route(String? gender) {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const LoginToYourAccountWidget._(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();

    void onContinue() {
      Navigator.of(context).push(VerifyScreen.route(_emailController.text));
    }

    void onFacebookLogin() {}
    return LogInPageWrapper(
      child: SingleChildScrollView(
        padding: MediaQuery.of(context).viewInsets, //! How expensive is this?
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Please provide your Email ID to \nlogin/ sign up before you place the order',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                verticalMargin48,
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                verticalMargin24,
                AppButton(
                  label: 'Continue',
                  style: AppButtonStyle.highlighted,
                  iconAsset: Assets.iconContinue,
                  onPressed: onContinue,
                ),
                verticalMargin16,
                const Text(
                  'or Login using',
                  textAlign: TextAlign.center,
                ),
                verticalMargin16,
                AppButton(
                  //TODO: style this button
                  label: 'Facebook',
                  style: AppButtonStyle.outlined,
                  onPressed: onFacebookLogin,
                ),
                verticalMargin48,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
