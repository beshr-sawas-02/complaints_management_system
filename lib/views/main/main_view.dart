import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/main_controller.dart';
import '../dashboard/dashboard_view.dart';
import '../complaints/complaints_view.dart';
import '../users/users_view.dart';
import '../categories/categories_view.dart';
import '../profile/profile_view.dart';

/// iOS 26 Inspired Main View with Advanced Glassmorphism
/// Features: Dynamic Island nav, Liquid animations, Ambient glow effects
class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: iOS26Theme.backgroundPrimary,
        extendBody: true,
        body: Stack(
          children: [
            // Dynamic ambient background
            const _AmbientGlowBackground(),

            // Content pages
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                DashboardView(),
                ComplaintsView(),
                UsersView(),
                CategoriesView(),
                ProfileView(),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Obx(() => _iOS26NavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        )),
      ),
    );
  }
}

/// iOS 26 Theme Colors
class iOS26Theme {
  // Backgrounds
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF0D0D0F);
  static const Color surfaceElevated = Color(0xFF1C1C1E);
  static const Color surfaceGlass = Color(0xFF2C2C2E);

  // Accents
  static const Color accentBlue = Color(0xFF0A84FF);
  static const Color accentIndigo = Color(0xFF5E5CE6);
  static const Color accentPurple = Color(0xFFBF5AF2);
  static const Color accentTeal = Color(0xFF64D2FF);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFF48484A);

  // Borders
  static const Color borderPrimary = Color(0xFF38383A);
  static const Color borderSubtle = Color(0xFF1D1D1F);

  // Gradients
  static const List<Color> liquidMetalGradient = [
    Color(0xFF0A84FF),
    Color(0xFF5E5CE6),
  ];

  static const List<Color> darkGlassGradient = [
    Color(0xFF2C2C2E),
    Color(0xFF1C1C1E),
  ];
}

/// Ambient Glow Background with reactive colors
class _AmbientGlowBackground extends StatelessWidget {
  const _AmbientGlowBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Primary ambient glow
        Positioned(
          top: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  iOS26Theme.accentBlue.withOpacity(0.15),
                  iOS26Theme.accentBlue.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Secondary ambient glow
        Positioned(
          top: 200,
          right: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  iOS26Theme.accentIndigo.withOpacity(0.12),
                  iOS26Theme.accentIndigo.withOpacity(0.03),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom accent glow
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  iOS26Theme.accentBlue.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// iOS 26 Navigation Bar with Dynamic Island aesthetics
class _iOS26NavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _iOS26NavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            height: 76,
            decoration: BoxDecoration(
              // Multi-layer glass effect
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  iOS26Theme.surfaceGlass.withOpacity(0.9),
                  iOS26Theme.surfaceElevated.withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: iOS26Theme.borderPrimary.withOpacity(0.3),
                width: 0.5,
              ),
              boxShadow: [
                // Outer shadow for depth
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 40,
                  offset: const Offset(0, 15),
                  spreadRadius: -10,
                ),
                // Inner glow
                BoxShadow(
                  color: iOS26Theme.accentBlue.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Top highlight line
                Positioned(
                  top: 0,
                  left: 24,
                  right: 24,
                  child: Container(
                    height: 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Navigation items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavItem(
                        index: 0,
                        icon: Iconsax.home_2,
                        activeIcon: Iconsax.home_15,
                        label: 'الرئيسية',
                        isSelected: currentIndex == 0,
                        onTap: () => onTap(0),
                      ),
                      _NavItem(
                        index: 1,
                        icon: Iconsax.message_text,
                        activeIcon: Iconsax.message_text_1,
                        label: 'الشكاوى',
                        isSelected: currentIndex == 1,
                        onTap: () => onTap(1),
                      ),
                      _CenterActionButton(
                        isSelected: currentIndex == 2,
                        onTap: () => onTap(2),
                      ),
                      _NavItem(
                        index: 3,
                        icon: Iconsax.category,
                        activeIcon: Iconsax.category5,
                        label: 'التصنيفات',
                        isSelected: currentIndex == 3,
                        onTap: () => onTap(3),
                      ),
                      _NavItem(
                        index: 4,
                        icon: Iconsax.user,
                        activeIcon: Iconsax.user5,
                        label: 'حسابي',
                        isSelected: currentIndex == 4,
                        onTap: () => onTap(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual navigation item
class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon container
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: isSelected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 + (value * 4),
                    vertical: 6 + (value * 2),
                  ),
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      Colors.transparent,
                      iOS26Theme.accentBlue.withOpacity(0.18),
                      value,
                    ),
                    borderRadius: BorderRadius.circular(12 + (value * 4)),
                  ),
                  child: Transform.scale(
                    scale: 1.0 + (value * 0.1),
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      color: Color.lerp(
                        iOS26Theme.textSecondary,
                        iOS26Theme.accentBlue,
                        value,
                      ),
                      size: 22,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            // Label with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: isSelected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: Color.lerp(
                      iOS26Theme.textSecondary,
                      iOS26Theme.accentBlue,
                      value,
                    ),
                    letterSpacing: -0.3,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Center floating action button with liquid metal effect
class _CenterActionButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CenterActionButton({
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CenterActionButton> createState() => _CenterActionButtonState();
}

class _CenterActionButtonState extends State<_CenterActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.4, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(_CenterActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 58,
              height: 50,
              decoration: BoxDecoration(
                // Dynamic gradient based on selection
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isSelected
                      ? iOS26Theme.liquidMetalGradient
                      : iOS26Theme.darkGlassGradient,
                ),
                borderRadius: BorderRadius.circular(widget.isSelected ? 20 : 18),
                border: Border.all(
                  color: widget.isSelected
                      ? Colors.white.withOpacity(0.25)
                      : iOS26Theme.borderPrimary.withOpacity(0.4),
                  width: 0.5,
                ),
                boxShadow: [
                  // Primary glow shadow
                  if (widget.isSelected)
                    BoxShadow(
                      color: iOS26Theme.accentBlue.withOpacity(_glowAnimation.value),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                      spreadRadius: -5,
                    ),
                  // Secondary glow
                  if (widget.isSelected)
                    BoxShadow(
                      color: iOS26Theme.accentIndigo.withOpacity(_glowAnimation.value * 0.6),
                      blurRadius: 35,
                      offset: const Offset(0, 12),
                      spreadRadius: -8,
                    ),
                  // Base shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                    spreadRadius: -3,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Top shine effect
                  if (widget.isSelected)
                    Positioned(
                      top: 1,
                      left: 8,
                      right: 8,
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  // Icon
                  Icon(
                    widget.isSelected ? Iconsax.people5 : Iconsax.people,
                    color: widget.isSelected
                        ? iOS26Theme.textPrimary
                        : iOS26Theme.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}