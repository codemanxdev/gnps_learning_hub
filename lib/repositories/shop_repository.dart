import 'package:flutter/material.dart';

import '../models/shop_item.dart';

/// The full list of items available in the shop, plus the free "default"
/// items every user starts with equipped in each avatar slot. Add new
/// items here — nothing else needs to change for a new item to show up,
/// since ShopScreen and the avatar customization screen render this list
/// directly and group it by category/slot.
class ShopRepository {
  List<ShopItem> getCatalog() => _catalog;

  static const List<ShopItem> _catalog = [
    ShopItem(
      id: 'avatar_sikh_boy_1',
      name: 'Amar',
      description: 'A cheerful mascot with a blue patka.',
      imageAssetPath: 'assets/avatars/boy1.svg',
      price: 150,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.base,
    ),
    ShopItem(
      id: 'avatar_sikh_boy_2',
      name: 'Jaspreet',
      description: 'A bright mascot with a maroon patka.',
      imageAssetPath: 'assets/avatars/boy2.svg',
      price: 150,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.base,
    ),
    ShopItem(
      id: 'avatar_sikh_girl_1',
      name: 'Simran',
      description: 'A warm mascot with an orange chunni.',
      imageAssetPath: 'assets/avatars/girl1.svg',
      price: 150,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.base,
    ),
    ShopItem(
      id: 'avatar_sikh_girl_2',
      name: 'Harleen',
      description: 'A friendly mascot with a teal chunni.',
      imageAssetPath: 'assets/avatars/girl2.svg',
      price: 150,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.base,
    ),

    // --- Turban slot (default "none" + purchasable) ---
    ShopItem(
      id: 'turban_none',
      name: 'No Turban',
      description: 'Bare-headed.',
      icon: Icons.circle_outlined,
      color: Colors.grey,
      price: 0,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.turban,
    ),
    ShopItem(
      id: 'turban_orange',
      name: 'Orange Turban',
      description: 'A vibrant orange turban.',
      icon: Icons.circle,
      color: Colors.deepOrange,
      price: 100,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.turban,
    ),

    // --- Clothes slot (default + purchasable) ---
    ShopItem(
      id: 'clothes_default',
      name: 'Casual Fit',
      description: 'Comfortable everyday clothes.',
      icon: Icons.checkroom,
      color: Colors.brown,
      price: 0,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.clothes,
    ),
    ShopItem(
      id: 'clothes_formal',
      name: 'Formal Outfit',
      description: 'Sharp and sophisticated.',
      icon: Icons.checkroom,
      color: Colors.black87,
      price: 120,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.clothes,
    ),

    // --- Accessory slot (default "none" + purchasable) ---
    ShopItem(
      id: 'accessory_none',
      name: 'No Accessory',
      description: 'Keep it simple.',
      icon: Icons.circle_outlined,
      color: Colors.grey,
      price: 0,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.accessory,
    ),
    ShopItem(
      id: 'accessory_glasses',
      name: 'Glasses',
      description: 'For a studious look.',
      icon: Icons.visibility,
      color: Colors.teal,
      price: 80,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.accessory,
    ),

    // --- Power-ups (unchanged) ---
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
  ];
}
