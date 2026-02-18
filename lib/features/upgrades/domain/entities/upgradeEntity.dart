import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeRarity.dart';

class UpgradeEntity {
  // final String id;
  final String title;
  final String description;
  final UpgradeRarity rarity;
  // final List<UpgradeTag> tags;
  final UpgradeEffect effect;

  const UpgradeEntity({
    // required this.id,
    required this.title,
    required this.description,
    required this.rarity,
    // required this.tags,
    required this.effect,
  });
}
