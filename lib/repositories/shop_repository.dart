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
    // --- Base mascot (default + purchasable) ---
    ShopItem(
      id: 'avatar_base_default',
      name: 'Classic Mascot',
      description: 'Your mascot\'s original look.',
      icon: Icons.face,
      color: Colors.blueGrey,
      price: 0,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.base,
    ),
    ShopItem(
      id: 'avatar_golden',
      name: 'Golden Mascot',
      description: 'A shiny golden look for your mascot.',
      icon: Icons.stars,
      color: Colors.amber,
      price: 150,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.base,
    ),
    ShopItem(
      id: 'avatar_ninja',
      name: 'Ninja Mascot',
      description: 'Sneaky and stealthy, for focused learners.',
      icon: Icons.theater_comedy,
      color: Colors.indigo,
      price: 150,
      category: ShopItemCategory.avatar,
      avatarSlot: AvatarSlot.base,
    ),
    ShopItem(
      id: 'avatar_royal',
      name: 'Royal Mascot',
      description: 'Fit for a Gurmukhi champion.',
      icon: Icons.emoji_events,
      color: Colors.deepPurple,
      price: 250,
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
