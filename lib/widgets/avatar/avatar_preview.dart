import 'package:flutter/material.dart';

import '../../models/shop_item.dart';

class AvatarPreview extends StatelessWidget {
  final Map<String, String> equippedItemIds;
  final List<ShopItem> catalog;

  const AvatarPreview({
    super.key,
    required this.equippedItemIds,
    required this.catalog,
  });

  ShopItem? _resolve(AvatarSlot slot) {
    final itemId = equippedItemIds[slot.name];
    if (itemId == null) return null;
    for (final item in catalog) {
      if (item.id == itemId) return item;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final base = _resolve(AvatarSlot.base);
    final turban = _resolve(AvatarSlot.turban);
    final clothes = _resolve(AvatarSlot.clothes);
    final accessory = _resolve(AvatarSlot.accessory);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;
        final badgeSize = size * 0.36;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: (base?.color ?? Colors.grey.shade300).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                base?.icon ?? Icons.person,
                size: size * 0.62,
                color: base?.color ?? Colors.grey.shade600,
              ),
            ),
            if (turban != null)
              Positioned(
                top: 0,
                child: _SlotBadge(item: turban, size: badgeSize),
              ),
            if (clothes != null)
              Positioned(
                bottom: 0,
                left: size * 0.02,
                child: _SlotBadge(item: clothes, size: badgeSize),
              ),
            if (accessory != null)
              Positioned(
                bottom: 0,
                right: size * 0.02,
                child: _SlotBadge(item: accessory, size: badgeSize),
              ),
          ],
        );
      },
    );
  }
}

class _SlotBadge extends StatelessWidget {
  final ShopItem item;
  final double size;

  const _SlotBadge({required this.item, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: item.color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(item.icon, size: size * 0.6, color: Colors.white),
    );
  }
}
