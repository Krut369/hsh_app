import 'package:flutter_riverpod/flutter_riverpod.dart';

// Bottom navigation index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// Controls FAB visibility on "More" tab
final showMoreOptionsProvider = StateProvider<bool>((ref) => false);
