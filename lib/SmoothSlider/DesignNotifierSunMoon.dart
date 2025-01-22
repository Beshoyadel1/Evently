import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DesignState { sun, moon }

class DesignNotifier extends StateNotifier<DesignState> {
  DesignNotifier() : super(DesignState.sun);

  void toggleDesign() {
    state = state == DesignState.sun ? DesignState.moon : DesignState.sun;
  }
}

// Define a provider for the DesignNotifier
final designProvider = StateNotifierProvider<DesignNotifier, DesignState>(
      (ref) => DesignNotifier(),
);
