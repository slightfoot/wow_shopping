import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/backend.dart';

enum DeviceType {
  unknown,
  phone,
  tablet,
}

enum DeviceOrientation {
  unknown,
  portrait,
  landscape,
}

@immutable
class DeviceTypeOrientationState {
  const DeviceTypeOrientationState({
    required this.deviceType,
    required this.orientation,
  });

  const DeviceTypeOrientationState.unknown()
      : deviceType = DeviceType.unknown,
        orientation = DeviceOrientation.unknown;

  final DeviceType deviceType;
  final DeviceOrientation orientation;

  bool get isTablet => deviceType == DeviceType.tablet;

  bool get isPhone => deviceType == DeviceType.phone;

  bool get isLandscape => orientation == DeviceOrientation.landscape;

  bool get isPortrait => orientation == DeviceOrientation.portrait;

  DeviceTypeOrientationState copyWith({
    DeviceType? deviceType,
    DeviceOrientation? orientation,
  }) {
    return DeviceTypeOrientationState(
      deviceType: deviceType ?? this.deviceType,
      orientation: orientation ?? this.orientation,
    );
  }
}

final deviceTypeNotifierProvider =
    ChangeNotifierProvider<DeviceTypeOrientationNotifier>(
  (ref) => DeviceTypeOrientationNotifier(),
);

class DeviceTypeOrientationNotifier extends ChangeNotifier with WidgetsBindingObserver {
  DeviceTypeOrientationNotifier();

  var _state = const DeviceTypeOrientationState.unknown();

  bool get isTablet => _state.isTablet;

  bool get isPhone => _state.isPhone;

  bool get isLandscape => _state.isLandscape;

  bool get isPortrait => _state.isPortrait;

  void init() {
    WidgetsBinding.instance.addObserver(this);
    updateDeviceType();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    updateDeviceType();
  }

  void updateDeviceType() {
    final view = ui.PlatformDispatcher.instance.implicitView!;
    final size = view.physicalSize / view.devicePixelRatio;

    bool updated = false;

    final deviceType = (size.shortestSide < 600) //
        ? DeviceType.phone
        : DeviceType.tablet;
    if (deviceType != _state.deviceType) {
      debugPrint('Device Type changed to: $deviceType');
      _state = _state.copyWith(deviceType: deviceType);
      updated = true;
    }

    final orientation = (size.width < size.height) //
        ? DeviceOrientation.portrait
        : DeviceOrientation.landscape;
    if (orientation != _state.orientation) {
      debugPrint('Orientation changed to: $orientation');
      _state = _state.copyWith(orientation: orientation);
      updated = true;
    }

    if (updated) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class DeviceTypeBuilder extends StatelessWidget {
  const DeviceTypeBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  final Widget Function(
    BuildContext context,
    DeviceTypeOrientationState state,
    Widget? child,
  ) builder;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.deviceType,
      builder: (BuildContext context, Widget? child) {
        return builder(context, context.deviceType._state, child);
      },
      child: child,
    );
  }
}
