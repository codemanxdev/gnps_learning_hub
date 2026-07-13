import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  // "None" sentinel items exist so the shop/equip system always has a
  // valid default, but they shouldn't render a visible badge.
  bool _isVisible(ShopItem? item) {
    if (item == null) return false;
    return item.id != DefaultItemIds.turbanNone &&
        item.id != DefaultItemIds.accessoryNone;
  }

  @override
  Widget build(BuildContext context) {
    final base = _resolve(AvatarSlot.base);
    final turban = _resolve(AvatarSlot.turban);
    final clothes = _resolve(AvatarSlot.clothes);
    final accessory = _resolve(AvatarSlot.accessory);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final bodySize = width * 0.85;
        final turbanSize = width * 0.4;
        final clothesSize = width * 0.4;
        final accessorySize = width * 0.3;

        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: height * 0.14,
              child: base?.imageAssetPath != null
                  ? SizedBox(
                      width: bodySize,
                      height: bodySize,
                      child: SvgPicture.asset(
                        base!.imageAssetPath!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Container(
                      width: bodySize,
                      height: bodySize,
                      decoration: BoxDecoration(
                        color: (base?.color ?? Colors.grey.shade300).withValues(
                          alpha: 0.18,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        base?.icon ?? Icons.person,
                        size: bodySize * 0.68,
                        color: base?.color ?? Colors.grey.shade600,
                      ),
                    ),
            ),
            if (_isVisible(turban))
              Positioned(
                top: 0,
                child: _SlotBadge(item: turban!, size: turbanSize),
              ),
            // clothes_default is a real garment, not a "none" sentinel —
            // it's meant to always render, so no visibility check here.
            if (clothes != null)
              Positioned(
                bottom: height * 0.06,
                child: _SlotBadge(item: clothes, size: clothesSize),
              ),
            if (_isVisible(accessory))
              Positioned(
                top: height * 0.32,
                right: width * 0.02,
                child: _SlotBadge(item: accessory!, size: accessorySize),
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
    if (item.imageAssetPath != null) {
      return SizedBox(
        width: size,
        height: size,
        child: SvgPicture.asset(item.imageAssetPath!, fit: BoxFit.contain),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: item.color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Icon(item.icon, size: size * 0.6, color: Colors.white),
    );
  }
}
