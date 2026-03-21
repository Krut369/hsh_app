import 'package:get/get.dart';

class BottomNavController extends GetxController {
  // Bottom navigation index
  final currentIndex = 0.obs;

  // Controls FAB visibility on "More" tab
  final showMoreOptions = false.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void toggleMoreOptions(bool show) {
    showMoreOptions.value = show;
  }
}
