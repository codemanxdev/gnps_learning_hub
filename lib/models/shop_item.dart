import 'package:flutter/material.dart';

enum ShopItemCategory { avatar, powerUp }

enum AvatarSlot { base, turban, clothes, accessory }

class ShopItem {
  final String id;
  final String name;
  final String description;
  final IconData? icon;
  final Color? color;
  final String? imageAssetPath;
  final int price;
  final ShopItemCategory category;
  final bool stackable;
  final AvatarSlot? avatarSlot;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    this.color,
    this.imageAssetPath,
    required this.price,
    required this.category,
    this.stackable = false,
    this.avatarSlot,
  }) : assert(
         category != ShopItemCategory.avatar || avatarSlot != null,
         'Avatar items must specify an avatarSlot',
       ),
       assert(
         imageAssetPath != null || (icon != null && color != null),
         'Item must specify either imageAssetPath or both icon and color',
       );
}
