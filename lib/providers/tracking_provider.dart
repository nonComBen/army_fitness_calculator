import 'package:acft_calculator/providers/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final trackingProvider = StateNotifierProvider<TrackingService, bool>(
    (ref) => TrackingService(ref.read(sharedPreferencesProvider)));

class TrackingService extends StateNotifier<bool> {
  final SharedPreferences prefs;
  TrackingService(this.prefs) : super(false);

  Future<void> init() async {
    if (this.prefs.getBool('trackingAllowed') == null) {
      PermissionStatus status = await Permission.appTrackingTransparency.status;
      if (status.isDenied) {
        status = await Permission.appTrackingTransparency.request();
      }
      state = status.isGranted;
      prefs.setBool('trackingAllowed', state);
    } else {
      state = this.prefs.getBool('trackingAllowed') ?? false;
    }
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
