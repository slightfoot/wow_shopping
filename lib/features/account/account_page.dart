import 'package:flutter/material.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';

@immutable
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Account'),
            verticalMargin48,
            verticalMargin48,
            AppButton(
              onPressed: () => authRepo.logout(),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
