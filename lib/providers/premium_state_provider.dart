import 'package:flutter_riverpod/flutter_riverpod.dart';

final premiumStateProvider =
    NotifierProvider<PremiumState, bool>(() => PremiumState());

class PremiumState extends Notifier<bool> {
  void setState(bool isPremium) {
    state = isPremium;
  }

  @override
  bool build() {
    return false; // Default to true, assuming the user has premium access initially
  }
}
