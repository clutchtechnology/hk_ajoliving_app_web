import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 用户信息模型
class UserInfo {
  final String username;
  final String? displayName;

  const UserInfo({
    required this.username,
    this.displayName,
  });

  // 序列化
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
    };
  }

  // 反序列化
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
    );
  }
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
  static const String _storageKey = 'auth_user_info';
  
  AuthNotifier() : super(const AuthState()) {
    // 构造函数中加载保存的登录状态
    _loadSavedAuth();
  }

  // 虚拟用户数据（用于测试）
  static const Map<String, Map<String, String>> _mockUsers = {
    'admin': {'password': '123456', 'displayName': '管理員'},
    'user': {'password': 'password', 'displayName': '普通用戶'},
    'test': {'password': 'test123', 'displayName': '測試用戶'},
  };

  /// 加载保存的认证信息
  Future<void> _loadSavedAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_storageKey);
      
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = UserInfo.fromJson(userMap);
        
        state = AuthState(
          isLoggedIn: true,
          user: user,
          isLoading: false,
        );
      }
    } catch (e) {
      // 如果加载失败，保持默认未登录状态
      print('加载登录状态失败: $e');
    }
  }

  /// 保存认证信息
  Future<void> _saveAuth(UserInfo user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_storageKey, userJson);
    } catch (e) {
      print('保存登录状态失败: $e');
    }
  }

  /// 清除认证信息
  Future<void> _clearAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('清除登录状态失败: $e');
    }
  }

  /// 登录
  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    
    // 模拟网络请求延迟
    await Future.delayed(const Duration(seconds: 1));
    
    // 验证虚拟用户
    if (_mockUsers.containsKey(username) && 
        _mockUsers[username]!['password'] == password) {
      final user = UserInfo(
        username: username,
        displayName: _mockUsers[username]!['displayName'],
      );
      
      // 保存到本地存储
      await _saveAuth(user);
      
      state = AuthState(
        isLoggedIn: true,
        user: user,
        isLoading: false,
      );
      return true;
    }
    
    state = state.copyWith(isLoading: false);
    return false;
  }

  /// 登出
  Future<void> logout() async {
    // 清除本地存储
    await _clearAuth();
    state = const AuthState();
  }
}

/// 认证状态提供者
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
