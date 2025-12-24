import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/layouts/main_layout.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/buy_page.dart';
import '../presentation/pages/rent_page.dart';
import '../presentation/pages/new_properties_page.dart';
import '../presentation/pages/serviced_apartments_page.dart';
import '../presentation/pages/transactions_page.dart';
import '../presentation/pages/furniture_page.dart';
import '../presentation/pages/valuation_page.dart';
import '../presentation/pages/school_net_page.dart';
import '../presentation/pages/agents_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/widgets/placeholder_page.dart';

/// 应用路由配置
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        // 首页
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),

        // 买房
        GoRoute(
          path: '/buy',
          builder: (context, state) => const BuyPage(),
        ),

        // 租房
        GoRoute(
          path: '/rent',
          builder: (context, state) => const RentPage(),
        ),

        // 新盘
        GoRoute(
          path: '/new-properties',
          builder: (context, state) => const NewPropertiesPage(),
        ),

        // 服务式住宅
        GoRoute(
          path: '/serviced-apartments',
          builder: (context, state) => const ServicedApartmentsPage(),
        ),

        // 屋苑成交
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionsPage(),
        ),

        // 物业估价
        GoRoute(
          path: '/valuation',
          builder: (context, state) => const ValuationPage(),
        ),

        // 家具
        GoRoute(
          path: '/furniture',
          builder: (context, state) => const FurniturePage(),
        ),

        // 置业按揭
        GoRoute(
          path: '/mortgage',
          builder: (context, state) => const PlaceholderPage(
            title: '置業按揭',
            icon: Icons.account_balance,
          ),
        ),

        // 新闻资讯
        GoRoute(
          path: '/news',
          builder: (context, state) => const PlaceholderPage(
            title: '新聞資訊',
            icon: Icons.article,
          ),
        ),

        // 校网
        GoRoute(
          path: '/school-net',
          builder: (context, state) => const SchoolNetPage(),
        ),

        // 地产代理
        GoRoute(
          path: '/agents',
          builder: (context, state) => const AgentsPage(),
        ),

        // 楼价指数
        GoRoute(
          path: '/price-index',
          builder: (context, state) => const PlaceholderPage(
            title: '易發樓價指數',
            icon: Icons.trending_up,
          ),
        ),

        // 房产详情
        GoRoute(
          path: '/property/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return PlaceholderPage(
              title: '房產詳情 #$id',
              icon: Icons.home_work,
            );
          },
        ),

        // 个人中心
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),

        // 购物车
        GoRoute(
          path: '/cart',
          builder: (context, state) => const PlaceholderPage(
            title: '購物車',
            icon: Icons.shopping_cart,
          ),
        ),

        // 登录
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),

        // 注册
        GoRoute(
          path: '/register',
          builder: (context, state) => const PlaceholderPage(
            title: '註冊',
            icon: Icons.person_add,
          ),
        ),
      ],
    ),
  ],
);
