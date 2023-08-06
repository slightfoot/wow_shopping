import 'package:flutter/material.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

@immutable
class ConnectionMonitor extends StatefulWidget {
  const ConnectionMonitor({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ConnectionMonitor> createState() => _ConnectionMonitorState();
}

class _ConnectionMonitorState extends State<ConnectionMonitor> {
  final connectivity = Connectivity();
  late final checkConnectivity = connectivity.checkConnectivity();
  late final onConnectivityChanged = connectivity.onConnectivityChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkConnectivity,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return emptyWidget;
        }
        return StreamBuilder(
          initialData: snapshot.requireData,
          stream: onConnectivityChanged,
          builder: (BuildContext context,
              AsyncSnapshot<ConnectivityResult> snapshot) {
            final result = snapshot.requireData;
            return Stack(
              children: [
                widget.child,
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: result != ConnectivityResult.none ? 0.0 : null,
                      child: Material(
                        color: Colors.red,
                        child: Padding(
                          padding: verticalPadding4 + horizontalPadding12,
                          child: const Text(
                            'Please check your internet connection',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
