import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/premium_state_provider.dart';
import '../providers/shared_preferences_provider.dart';
import '../services/purchases_service.dart';

final purchasesProvider = Provider<PurchasesService>((ref) {
  return PurchasesService(
    premiumState: ref.read(premiumStateProvider.notifier),
    prefs: ref.read(sharedPreferencesProvider),
  );
});
