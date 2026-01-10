import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/search.dart';

/// 搜索建议项组件
class SearchSuggestionItem extends StatelessWidget {
  final SearchSuggestion suggestion;
  final VoidCallback onTap;

  const SearchSuggestionItem({
    super.key,
    required this.suggestion,
    required this.onTap,
  });

  IconData _getIconByType() {
    switch (suggestion.type) {
      case 'property':
        return Icons.home;
      case 'estate':
        return Icons.apartment;
      case 'agent':
        return Icons.person;
      case 'district':
        return Icons.location_on;
      default:
        return Icons.search;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _getIconByType(),
        color: AppColors.textTertiary,
        size: 20,
      ),
      title: Text(
        suggestion.text,
        style: const TextStyle(
          fontSize: AppStyles.fontSizeBody,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: suggestion.count > 0
          ? Text(
              '${suggestion.count} 個結果',
              style: const TextStyle(
                fontSize: AppStyles.fontSizeSmall,
                color: AppColors.textTertiary,
              ),
            )
          : null,
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppStyles.spacing16,
      ),
    );
  }
}

/// 搜索历史项组件
class SearchHistoryItem extends StatelessWidget {
  final SearchHistory history;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SearchHistoryItem({
    super.key,
    required this.history,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.history,
        color: AppColors.textTertiary,
        size: 20,
      ),
      title: Text(
        history.query,
        style: const TextStyle(
          fontSize: AppStyles.fontSizeBody,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 18),
        color: AppColors.textTertiary,
        onPressed: onDelete,
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppStyles.spacing16,
      ),
    );
  }
}

/// 全局搜索结果项组件
class GlobalSearchResultItem extends StatelessWidget {
  final GlobalSearchResult result;
  final VoidCallback onTap;

  const GlobalSearchResultItem({
    super.key,
    required this.result,
    required this.onTap,
  });

  IconData _getIconByType() {
    switch (result.type) {
      case 'property':
        return Icons.home;
      case 'estate':
        return Icons.apartment;
      case 'agent':
        return Icons.person;
      case 'district':
        return Icons.location_on;
      default:
        return Icons.info;
    }
  }

  String _getTypeLabel() {
    switch (result.type) {
      case 'property':
        return '房產';
      case 'estate':
        return '屋苑';
      case 'agent':
        return '代理人';
      case 'district':
        return '地區';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppStyles.spacing12),
      child: ListTile(
        leading: result.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
                child: Image.network(
                  result.imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: AppColors.background,
                      child: Icon(_getIconByType(), color: AppColors.textTertiary),
                    );
                  },
                ),
              )
            : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
                ),
                child: Icon(_getIconByType(), color: AppColors.textTertiary),
              ),
        title: Text(
          result.title,
          style: const TextStyle(
            fontSize: AppStyles.fontSizeBody,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                result.subtitle!,
                style: const TextStyle(
                  fontSize: AppStyles.fontSizeSmall,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
              ),
              child: Text(
                _getTypeLabel(),
                style: TextStyle(
                  fontSize: AppStyles.fontSizeSmall,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        onTap: onTap,
        contentPadding: const EdgeInsets.all(AppStyles.spacing12),
      ),
    );
  }
}
