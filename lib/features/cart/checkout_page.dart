import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/cart/widgets/checkout_panel.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage._();

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const CheckoutPage._(),
        );
      },
    );
  }

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TopNavBar(title: Text('Checkout')),
            const Expanded(
              child: Center(child: Text('[checkout content]')),
            ),
            CheckoutPanel(
              onPressed: () {
                // FIXME: goto payment
              },
              label: 'Payment',
            ),
            SizedBox(
              height: MediaQuery.viewPaddingOf(context).bottom,
              child: const ColoredBox(color: appLightGreyColor),
            ),
          ],
        ),
      ),
    );
  }
}
