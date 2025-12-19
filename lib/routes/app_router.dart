import 'package:go_router/go_router.dart';
import '../presentation/layouts/main_layout.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/widgets/common/placeholder_page.dart';

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
          builder: (context, state) => const PlaceholderPage(
            title: '買樓',
            icon: Icons.business,
          ),
        ),

        // 租房
        GoRoute(
          path: '/rent',
          builder: (context, state) => const PlaceholderPage(
            title: '租屋',
            icon: Icons.apartment,
          ),
        ),

        // 新盘
        GoRoute(
          path: '/new-properties',
          builder: (context, state) => const PlaceholderPage(
            title: '新盤',
            icon: Icons.new_releases,
          ),
        ),

        // 服务式住宅
        GoRoute(
          path: '/serviced-apartments',
          builder: (context, state) => const PlaceholderPage(
            title: '服務式住宅',
            icon: Icons.hotel,
          ),
        ),

        // 屋苑成交
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const PlaceholderPage(
            title: '屋苑成交',
            icon: Icons.receipt_long,
          ),
        ),

        // 物业估价
        GoRoute(
          path: '/valuation',
          builder: (context, state) => const PlaceholderPage(
            title: '物業估價',
            icon: Icons.calculate,
          ),
        ),

        // 家具
        GoRoute(
          path: '/furniture',
          builder: (context, state) => const PlaceholderPage(
            title: '家具',
            icon: Icons.weekend,
          ),
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
          builder: (context, state) => const PlaceholderPage(
            title: '校網',
            icon: Icons.school,
          ),
        ),

        // 地产代理
        GoRoute(
          path: '/agents',
          builder: (context, state) => const PlaceholderPage(
            title: '地產代理',
            icon: Icons.people,
          ),
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
          builder: (context, state) => const PlaceholderPage(
            title: '個人中心',
            icon: Icons.person,
          ),
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
          builder: (context, state) => const PlaceholderPage(
            title: '登入',
            icon: Icons.login,
          ),
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
