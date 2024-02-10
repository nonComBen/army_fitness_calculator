import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final trackingProvider =
    StateNotifierProvider<TrackingService, bool>((ref) => TrackingService());

class TrackingService extends StateNotifier<bool> {
  TrackingService() : super(false);

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
