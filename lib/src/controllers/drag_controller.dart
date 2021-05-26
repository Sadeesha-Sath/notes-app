import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class DragController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController animationController;

  @override
  void onInit() {
    animationController = AnimationController.unbounded(vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
