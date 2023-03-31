import 'package:flutter_riverpod/flutter_riverpod.dart';

final premiumStateProvider =
    StateNotifierProvider<PremiumState, bool>((ref) => PremiumState());

class PremiumState extends StateNotifier<bool> {
  PremiumState() : super(true);

  void setState(bool isPremium) {
    state = true;
  }
}
