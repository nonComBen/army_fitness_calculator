import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/purchases_service.dart';

final purchasesProvider = Provider<PurchasesService>((ref) {
  return PurchasesService();
});
