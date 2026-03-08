import 'package:bouncer/core/audio_manager.dart';
import 'package:bouncer/core/effects/flashController.dart';
import 'package:bouncer/features/game/gameCoordinator.dart';
// import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEntity.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeRarity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpgradeWidget extends StatelessWidget {
  const UpgradeWidget(this.upgradeEntity, {super.key});
  // final IconData iconData;
  final UpgradeEntity upgradeEntity;

  IconData _chooseIconData(UpgradeEntity entity) {
    // print(entity.title);
    switch (entity.title) {
      case 'IncreaseBallPower':
        return Icons.arrow_circle_up;
      case 'IncreasePlatformSize':
        return Icons.sync_alt;
      case 'AddOneBall':
        return Icons.plus_one;
      default:
        throw UnimplementedError('Unknown upgrade: ${entity.title}');
    }
  }

  Color _chooseBorderColor(UpgradeRarity rarity) {
    switch (rarity) {
      case UpgradeRarity.rare:
        return Colors.blue;
      case UpgradeRarity.epic:
        return Colors.purpleAccent;
      default:
        throw UnimplementedError(
            'Unimplemented color for upgrade rarity: $rarity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: _chooseBorderColor(upgradeEntity.rarity))),
        child: IconButton(
          onPressed: () {
            context.read<FlashController>().trigger();
            AudioManager().playAddUpdateSound();
            context.read<GameCoordinator>().applyUpgrade(upgradeEntity.effect);
            context.read<GameCoordinator>().startNextLevel();
          },
          icon: Icon(
            _chooseIconData(upgradeEntity),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
