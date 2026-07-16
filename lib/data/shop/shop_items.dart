import 'package:flutter/material.dart';
import '../../models/shop_item.dart';

const List<ShopItem> purchasableItems = [
  ShopItem(
    id: 'turban_orange',
    name: 'Orange Turban',
    description: 'A vibrant orange turban.',
    imageAssetPath: 'assets/shop/turban_orange.svg',
    price: 100,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.turban,
  ),
  ShopItem(
    id: 'clothes_formal',
    name: 'Formal Outfit',
    description: 'Sharp and sophisticated.',
    imageAssetPath: 'assets/shop/clothes_formal.svg',
    price: 120,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.clothes,
  ),
  ShopItem(
    id: 'accessory_glasses',
    name: 'Glasses',
    description: 'For a studious look.',
    imageAssetPath: 'assets/shop/accessory_glasses.svg',
    price: 80,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.accessory,
  ),
  ShopItem(
    id: 'powerup_streak_freeze',
    name: 'Streak Freeze',
    description: 'Protects your streak if you miss a day.',
    icon: Icons.ac_unit,
    color: Colors.lightBlue,
    price: 50,
    category: ShopItemCategory.powerUp,
    stackable: true,
  ),
  ShopItem(
    id: 'powerup_extra_life',
    name: 'Extra Heart',
    description: 'Gives you an extra life in games.',
    icon: Icons.favorite,
    color: Colors.red,
    price: 20,
    category: ShopItemCategory.powerUp,
    stackable: true,
  ),
];
