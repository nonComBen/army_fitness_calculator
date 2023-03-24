import 'package:acft_calculator/providers/premium_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/purchases_service.dart';

final purchasesProvider = Provider<PurchasesService>((ref) {
  return PurchasesService(
      premiumState: ref.read(premiumStateProvider.notifier));
});
