import 'package:bouncer/features/game/gameCoordinator.dart';
import 'package:bouncer/features/game/presentacion/widgets/upgradeWidget.dart';
// import 'package:bouncer/features/game/viewModels/gameScreenViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEntity.dart';
// import 'package:bouncer/features/upgrades/upgradeManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpgradesToChooseWidget extends StatefulWidget {
  const UpgradesToChooseWidget({super.key});

  @override
  State<UpgradesToChooseWidget> createState() => _UpgradesToChooseWidgetState();
}

class _UpgradesToChooseWidgetState extends State<UpgradesToChooseWidget> {
  List<UpgradeEntity> upgrades = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    upgrades = context.read<GameCoordinator>().getUpgrades();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(upgrades.length, (index) {
        UpgradeEntity upgradeEntity = upgrades[index];
        return UpgradeWidget(upgradeEntity);
      }),
    );
  }
}
