import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/reward_config.dart';
import '../models/progress.dart';
import '../models/shop_item.dart';
import '../providers/progress_providers.dart';
import '../providers/shop_providers.dart';
import '../services/progress_service.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Shop')),
      body: SafeArea(
        child: progressAsync.when(
          data: (progress) => _ShopContent(progress: progress),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('Could not load shop.')),
        ),
      ),
    );
  }
}

class _ShopContent extends ConsumerWidget {
  final LocalProgress progress;

  const _ShopContent({required this.progress});

  String _categoryLabel(ShopItemCategory category) {
    switch (category) {
      case ShopItemCategory.avatar:
        return 'Avatars';
      case ShopItemCategory.powerUp:
        return 'Power-ups';
    }
  }

  Future<void> _buy(BuildContext context, WidgetRef ref, ShopItem item) async {
    final result = await ref.read(progressProvider.notifier).purchaseItem(item);
    if (!context.mounted) return;

    final message = switch (result) {
      PurchaseResult.success => 'You bought ${item.name}!',
      PurchaseResult.insufficientGems =>
        'Not enough ${RewardConfig.labelPlural} yet.',
      PurchaseResult.alreadyOwned => 'You already own ${item.name}.',
    };

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(progressServiceProvider);
    final catalog = ref.watch(shopCatalogProvider);

    // Free default items (price 0) exist so every avatar slot always has
    // something equipped, but they're not meant to be "bought" — hide
    // them from the shop grid so this screen only shows real purchases.
    final purchasableCatalog = catalog.where((i) => i.price > 0).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _GemBalance(points: progress.totalPoints),
        const SizedBox(height: 24),
        for (final category in ShopItemCategory.values)
          if (purchasableCatalog.any((i) => i.category == category)) ...[
            Text(
              _categoryLabel(category),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
              children: [
                for (final item in purchasableCatalog.where(
                  (i) => i.category == category,
                ))
                  _ShopItemCard(
                    item: item,
                    owned: service.isItemOwned(progress, item.id),
                    quantity: service.itemQuantity(progress, item.id),
                    canAfford: progress.totalPoints >= item.price,
                    onBuy: () => _buy(context, ref, item),
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],
      ],
    );
  }
}

class _GemBalance extends StatelessWidget {
  final int points;

  const _GemBalance({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(RewardConfig.icon, color: RewardConfig.color, size: 28),
          const SizedBox(width: 10),
          Text(
            '$points',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 6),
          Text(
            RewardConfig.labelPlural,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final ShopItem item;
  final bool owned;
  final int quantity;
  final bool canAfford;
  final VoidCallback onBuy;

  const _ShopItemCard({
    required this.item,
    required this.owned,
    required this.quantity,
    required this.canAfford,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final isSoldOut = owned && !item.stackable;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          item.imageAssetPath != null
              ? SvgPicture.asset(item.imageAssetPath!, width: 52, height: 52)
              : Icon(item.icon, color: item.color, size: 52),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (item.stackable && quantity > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'Owned: $quantity',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: isSoldOut
                ? const OutlinedButton(onPressed: null, child: Text('Owned'))
                : ElevatedButton(
                    onPressed: canAfford ? onBuy : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(RewardConfig.icon, size: 14),
                        const SizedBox(width: 4),
                        Text('${item.price}'),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
