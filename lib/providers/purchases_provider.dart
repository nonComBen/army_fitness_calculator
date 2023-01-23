import '../services/purchases_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final purchasesProvider = Provider<PurchasesService>((ref) {
  return PurchasesService();
});
