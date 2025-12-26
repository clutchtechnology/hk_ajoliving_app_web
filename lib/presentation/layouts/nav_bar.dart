import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../providers/auth_provider.dart';

/// 顶部导航栏组件
class NavBar extends ConsumerStatefulWidget {
  const NavBar({super.key});

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  String? _hoveredItem;

  // 导航菜单项列表
  final List<NavMenuItem> _menuItems = [
    const NavMenuItem(label: '地產主頁', route: '/'),
    const NavMenuItem(label: '買樓', route: '/buy'),
    const NavMenuItem(label: '租屋', route: '/rent'),
    const NavMenuItem(label: '新盤', route: '/new-properties'),
    const NavMenuItem(label: '服務式住宅', route: '/serviced-apartments'),
    const NavMenuItem(label: '屋苑成交', route: '/transactions'),
    const NavMenuItem(label: '物業估價', route: '/valuation'),
    const NavMenuItem(label: '家具', route: '/furniture'),
    const NavMenuItem(label: '置業按揭', route: '/mortgage'),
    const NavMenuItem(label: '新聞資訊', route: '/news'),
    const NavMenuItem(label: '校網', route: '/school-net'),
    const NavMenuItem(label: '地產代理', route: '/agents'),
    const NavMenuItem(label: '易發樓價指數', route: '/price-index'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      height: AppStyles.navBarHeight,
      decoration: BoxDecoration(
        color: AppColors.navBarBackground,
        border: Border(
          bottom: BorderSide(
            color: AppColors.navBarBorder,
            width: 1,
          ),
        ),
        boxShadow: AppStyles.shadowSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppStyles.navBarPaddingHorizontal,
        ),
        child: Row(
          children: [
            // Logo
            _buildLogo(),
            const SizedBox(width: AppStyles.spacing32),

            // 导航菜单
            Expanded(
              child: _buildNavigationMenu(currentRoute),
            ),

            // 用户信息和购物车
            _buildUserSection(),
          ],
        ),
      ),
    );
  }

  /// 构建 Logo
  Widget _buildLogo() {
    return InkWell(
      onTap: () => context.go('/'),
      child: Container(
        width: AppStyles.navBarLogoWidth,
        alignment: Alignment.center,
        child: const Text(
          'AJO Living',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  /// 构建导航菜单
  Widget _buildNavigationMenu(String currentRoute) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _menuItems.map((item) {
          final isActive = currentRoute == item.route;
          final isHovered = _hoveredItem == item.route;

          return MouseRegion(
            onEnter: (_) => setState(() => _hoveredItem = item.route),
            onExit: (_) => setState(() => _hoveredItem = null),
            child: InkWell(
              onTap: () => context.go(item.route),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppStyles.spacing12,
                  vertical: AppStyles.spacing8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: AppStyles.fontSizeBody,
                        color: isActive || isHovered
                            ? AppColors.navBarTextHover
                            : AppColors.navBarText,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 激活状态下划线
                    Container(
                      height: 2,
                      width: 24,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建用户区域（用户信息 + 购物车）
  Widget _buildUserSection() {
    // 从 Riverpod 获取用户登录状态
    final authState = ref.watch(authProvider);
    final bool isLoggedIn = authState.isLoggedIn;
    final String? userName = authState.user?.displayName;
    final int cartItemCount = 0;

    return Row(
      children: [
        // 购物车
        _buildCartButton(cartItemCount),
        const SizedBox(width: AppStyles.spacing16),

        // 用户信息
        _buildUserButton(isLoggedIn, userName),
      ],
    );
  }

  /// 构建收藏按钮
  Widget _buildCartButton(int itemCount) {
    return InkWell(
      onTap: () => context.go('/favorites'),
      child: Container(
        padding: const EdgeInsets.all(AppStyles.spacing8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.favorite_border,
              color: AppColors.textPrimary,
              size: 24,
            ),
            if (itemCount > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建用户按钮
  Widget _buildUserButton(bool isLoggedIn, String? userName) {
    return InkWell(
      onTap: () {
        if (isLoggedIn) {
          context.go('/profile');
        } else {
          context.go('/login');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppStyles.spacing16,
          vertical: AppStyles.spacing8,
        ),
        decoration: BoxDecoration(
          color: isLoggedIn ? AppColors.primary.withOpacity(0.1) : null,
          border: Border.all(
            color: isLoggedIn ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              isLoggedIn ? Icons.account_circle : Icons.person_outline,
              color: isLoggedIn ? AppColors.primary : AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: AppStyles.spacing8),
            Text(
              isLoggedIn ? (userName ?? '個人中心') : '登入',
              style: TextStyle(
                fontSize: AppStyles.fontSizeBody,
                color: isLoggedIn ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 导航菜单项数据模型
class NavMenuItem {
  final String label;
  final String route;

  const NavMenuItem({
    required this.label,
    required this.route,
  });
}
