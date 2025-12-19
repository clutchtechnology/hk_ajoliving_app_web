# 国际化配置说明

## 支持语言
- 繁体中文 (zh_HK) - 默认
- 简体中文 (zh_CN)
- English (en)

## 使用方法
在代码中使用：
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 在 Widget 中
Text(AppLocalizations.of(context)!.home)
```
