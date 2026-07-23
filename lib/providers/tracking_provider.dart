import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final trackingProvider =
    NotifierProvider<TrackingService, bool>(() => TrackingService());

class TrackingService extends Notifier<bool> {
  TrackingService();

  @override
  bool build() {
    return false; // Default to false, assuming tracking is not allowed initially
  }

  Future<void> init() async {
    PermissionStatus status = await Permission.appTrackingTransparency.status;
    if (status.isDenied) {
      status = await Permission.appTrackingTransparency.request();
    }
    state = status.isGranted;
  }

  bool get trackingAllowed {
    return state;
  }

  void allowTracking() {
    state = true;
  }

  void disallowTracking() {
    state = false;
  }
}
