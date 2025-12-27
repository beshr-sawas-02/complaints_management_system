import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/categories_controller.dart';
import '../../data/models/category_model.dart';
import '../../utils/helpers.dart';
import '../../routes/app_routes.dart';

/// iOS 26 Inspired Categories View
class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: _iOS26FAB(
          onTap: () => Get.toNamed(AppRoutes.categoryForm),
        ),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Header
              SliverToBoxAdapter(
                child: _iOS26Header(),
              ),
              // Statistics Card
              SliverToBoxAdapter(
                child: _StatisticsCard(controller: controller),
              ),
              // Search Bar
              SliverToBoxAdapter(
                child: _SearchSection(controller: controller),
              ),
            ];
          },
          body: _CategoriesListBody(controller: controller),
        ),
      ),
    );
  }
}

/// iOS 26 Color System
class iOS26Colors {
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF0D0D0F);
  static const Color surfaceElevated = Color(0xFF1C1C1E);
  static const Color surfaceGlass = Color(0xFF2C2C2E);
  static const Color surfaceCard = Color(0xFF1A1A1C);

  static const Color accentBlue = Color(0xFF0A84FF);
  static const Color accentIndigo = Color(0xFF5E5CE6);
  static const Color accentPurple = Color(0xFFBF5AF2);
  static const Color accentTeal = Color(0xFF64D2FF);
  static const Color accentGreen = Color(0xFF30D158);
  static const Color accentOrange = Color(0xFFFF9F0A);
  static const Color accentRed = Color(0xFFFF453A);
  static const Color accentYellow = Color(0xFFFFD60A);
  static const Color accentMint = Color(0xFF00C7BE);

  static const Color textPrimary = Color(0xFFE5E5E7);
  static const Color textSecondary = Color(0xFF98989F);
  static const Color textTertiary = Color(0xFF636366);

  static const Color borderPrimary = Color(0xFF38383A);
  static const Color borderSubtle = Color(0xFF1D1D1F);
}

/// iOS 26 Header
class _iOS26Header extends StatelessWidget {
  const _iOS26Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: const Text(
        'التصنيفات',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: iOS26Colors.textPrimary,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}

/// Statistics Card
class _StatisticsCard extends StatelessWidget {
  final CategoriesController controller;

  const _StatisticsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = controller.statistics.value;
      if (stats == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A5F),
              Color(0xFF0F2744),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: iOS26Colors.accentBlue.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iOS26Colors.accentBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: iOS26Colors.accentBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Iconsax.category5,
                color: iOS26Colors.accentBlue,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            // Stats Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Helpers.formatNumber(stats.totalCategories),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: iOS26Colors.textPrimary,
                      letterSpacing: -1,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'إجمالي التصنيفات',
                    style: TextStyle(
                      fontSize: 14,
                      color: iOS26Colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Decorative Element
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iOS26Colors.accentBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.chart_2,
                color: iOS26Colors.accentBlue,
                size: 22,
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Search Section
class _SearchSection extends StatelessWidget {
  final CategoriesController controller;

  const _SearchSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: _iOS26SearchBar(controller: controller),
    );
  }
}

/// iOS 26 Search Bar
class _iOS26SearchBar extends StatefulWidget {
  final CategoriesController controller;

  const _iOS26SearchBar({required this.controller});

  @override
  State<_iOS26SearchBar> createState() => _iOS26SearchBarState();
}

class _iOS26SearchBarState extends State<_iOS26SearchBar> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isFocused
              ? iOS26Colors.accentBlue.withOpacity(0.6)
              : iOS26Colors.borderPrimary.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.search_normal,
            color: _isFocused
                ? iOS26Colors.accentBlue
                : iOS26Colors.textTertiary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller.searchController,
              focusNode: _focusNode,
              onChanged: widget.controller.setSearchQuery,
              style: const TextStyle(
                color: iOS26Colors.textPrimary,
                fontSize: 15,
              ),
              cursorColor: iOS26Colors.accentBlue,
              decoration: const InputDecoration(
                hintText: 'بحث في التصنيفات...',
                hintStyle: TextStyle(
                  color: iOS26Colors.textTertiary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
              ),
            ),
          ),
          Obx(() {
            if (widget.controller.searchQuery.value.isNotEmpty) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.controller.searchController.clear();
                  widget.controller.setSearchQuery('');
                },
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: iOS26Colors.textTertiary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 12,
                    color: iOS26Colors.backgroundPrimary,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

/// Categories List Body
class _CategoriesListBody extends StatelessWidget {
  final CategoriesController controller;

  const _CategoriesListBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.categories.isEmpty) {
        return const _LoadingState();
      }

      if (controller.categories.isEmpty) {
        return _EmptyState(onRefresh: controller.refreshCategories);
      }

      return RefreshIndicator(
        onRefresh: controller.refreshCategories,
        color: iOS26Colors.accentBlue,
        backgroundColor: iOS26Colors.surfaceElevated,
        child: ListView.builder(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 160),
          itemCount: controller.categories.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.categories.length) {
              return const _LoadMoreIndicator();
            }
            return _CategoryCard(
              category: controller.categories[index],
              index: index,
              onEdit: () {
                controller.prepareForEdit(controller.categories[index]);
                Get.toNamed(
                  AppRoutes.categoryForm,
                  arguments: {'category': controller.categories[index]},
                );
              },
              onDelete: () {
                controller.deleteCategory(controller.categories[index].id!);
              },
            );
          },
        ),
      );
    });
  }
}

/// Category Card
class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  // Generate color based on index
  Color get _accentColor {
    final colors = [
      iOS26Colors.accentPurple,
      iOS26Colors.accentBlue,
      iOS26Colors.accentTeal,
      iOS26Colors.accentGreen,
      iOS26Colors.accentOrange,
      iOS26Colors.accentMint,
    ];
    return colors[index % colors.length];
  }

  IconData get _icon {
    final icons = [
      Iconsax.folder5,
      Iconsax.document5,
      Iconsax.task_square5,
      Iconsax.clipboard_text5,
      Iconsax.note5,
      Iconsax.archive_15,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            // يمكن إضافة تفاصيل التصنيف هنا
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _accentColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _icon,
                    color: _accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.complaintItem,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: iOS26Colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: iOS26Colors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Menu Button
                _PopupMenuButton(
                  onEdit: onEdit,
                  onDelete: onDelete,
                  accentColor: _accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Popup Menu Button
class _PopupMenuButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color accentColor;

  const _PopupMenuButton({
    required this.onEdit,
    required this.onDelete,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        HapticFeedback.lightImpact();
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceGlass,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Iconsax.more,
          color: iOS26Colors.textSecondary,
          size: 18,
        ),
      ),
      color: iOS26Colors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: iOS26Colors.borderPrimary.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iOS26Colors.accentBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.edit,
                  size: 16,
                  color: iOS26Colors.accentBlue,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'تعديل',
                style: TextStyle(
                  color: iOS26Colors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iOS26Colors.accentRed.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.trash,
                  size: 16,
                  color: iOS26Colors.accentRed,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'حذف',
                style: TextStyle(
                  color: iOS26Colors.accentRed,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// iOS 26 FAB
class _iOS26FAB extends StatelessWidget {
  final VoidCallback onTap;

  const _iOS26FAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [iOS26Colors.accentBlue, iOS26Colors.accentIndigo],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: iOS26Colors.accentBlue.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

/// Loading State
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: iOS26Colors.accentBlue,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل التصنيفات...',
            style: TextStyle(
              color: iOS26Colors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty State
class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: iOS26Colors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Iconsax.category,
                color: iOS26Colors.textTertiary,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد تصنيفات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: iOS26Colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'لم يتم العثور على أي تصنيفات',
              style: TextStyle(
                fontSize: 15,
                color: iOS26Colors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onRefresh();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: iOS26Colors.accentBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.refresh,
                      size: 18,
                      color: iOS26Colors.accentBlue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'تحديث',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: iOS26Colors.accentBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Load More Indicator
class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: iOS26Colors.accentBlue,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}