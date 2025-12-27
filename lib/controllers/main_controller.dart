import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MainController extends GetxController with GetSingleTickerProviderStateMixin {
  // Observable state
  final RxInt currentIndex = 0.obs;
  final RxBool isNavigating = false.obs;

  // Controllers
  late final PageController pageController;
  late final AnimationController _navAnimController;

  // Animation
  late final Animation<double> navAnimation;

  @override
  void onInit() {
    super.onInit();

    // Initialize page controller with smooth physics
    pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );

    // Initialize animation controller for nav bar effects
    _navAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    navAnimation = CurvedAnimation(
      parent: _navAnimController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    _navAnimController.dispose();
    super.onClose();
  }

  /// Change page with smooth animation
  void changePage(int index) {
    if (currentIndex.value == index) return;
    if (isNavigating.value) return;

    isNavigating.value = true;

    // Trigger haptic feedback based on distance
    final distance = (currentIndex.value - index).abs();
    if (distance > 1) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }

    currentIndex.value = index;

    // Animate to page with custom curve
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    ).then((_) {
      isNavigating.value = false;
    });

    // Trigger nav bar animation
    _navAnimController.forward(from: 0);
  }

  /// Handle page change from swipe (if enabled)
  void onPageChanged(int index) {
    if (currentIndex.value != index) {
      HapticFeedback.selectionClick();
      currentIndex.value = index;
    }
  }

  /// Get animation value for external use
  double get animationValue => navAnimation.value;

  /// Check if specific index is active
  bool isActive(int index) => currentIndex.value == index;
}