import 'package:bouncer/core/audio_manager.dart';
import 'package:bouncer/core/effects/flashController.dart';
import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEntity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpgradeWidget extends StatelessWidget {
  const UpgradeWidget(this.upgradeEntity, {super.key});
  // final IconData iconData;
  final UpgradeEntity upgradeEntity;

  IconData _chooseIconData(UpgradeEntity entity) {
    switch (entity.title) {
      case 'IncreaseBallPower':
        return Icons.arrow_circle_up;
      case 'IncreasePlatformSize':
        return Icons.sync_alt;
      default:
        throw UnimplementedError('Unknown upgrade: ${entity.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: IconButton(
          onPressed: () {
            context.read<FlashController>().trigger();
            AudioManager().playAddUpdateSound();
            context.read<GameViewModel>().addUpgrade(upgradeEntity);
            context.read<GameViewModel>().startNextLevel();
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
