import 'package:acft_calculator/services/ad_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adProvider = Provider<AdService>((ref) {
  return AdService();
});
