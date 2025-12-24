import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 用户信息模型
class UserInfo {
  final String username;
  final String? displayName;

  const UserInfo({
    required this.username,
    this.displayName,
  });
}

/// 认证状态
class AuthState {
  final bool isLoggedIn;
  final UserInfo? user;
  final bool isLoading;

  const AuthState({
    this.isLoggedIn = false,
    this.user,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    UserInfo? user,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 认证状态通知器
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  // 虚拟用户数据（用于测试）
  static const Map<String, Map<String, String>> _mockUsers = {
    'admin': {'password': '123456', 'displayName': '管理員'},
    'user': {'password': 'password', 'displayName': '普通用戶'},
    'test': {'password': 'test123', 'displayName': '測試用戶'},
  };

  /// 登录
  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    
    // 模拟网络请求延迟
    await Future.delayed(const Duration(seconds: 1));
    
    // 验证虚拟用户
    if (_mockUsers.containsKey(username) && 
        _mockUsers[username]!['password'] == password) {
      state = AuthState(
        isLoggedIn: true,
        user: UserInfo(
          username: username,
          displayName: _mockUsers[username]!['displayName'],
        ),
        isLoading: false,
      );
      return true;
    }
    
    state = state.copyWith(isLoading: false);
    return false;
  }

  /// 登出
  void logout() {
    state = const AuthState();
  }
}

/// 认证状态提供者
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
