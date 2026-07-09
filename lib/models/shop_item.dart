import 'package:flutter/material.dart';

enum ShopItemCategory { avatar, powerUp }

enum AvatarSlot { base, turban, clothes, accessory }

class ShopItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int price;
  final ShopItemCategory category;
  final bool stackable;
  final AvatarSlot? avatarSlot;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.price,
    required this.category,
    this.stackable = false,
    this.avatarSlot,
  }) : assert(
         category != ShopItemCategory.avatar || avatarSlot != null,
         'Avatar items must specify an avatarSlot',
       );
}
