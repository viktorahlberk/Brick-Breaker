import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/features/game/gameCoordinator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BonusesSideDrawer extends StatelessWidget {
  // final GlobalKey<ScaffoldState> scaffoldKey;
  const BonusesSideDrawer({
    super.key,
    // required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<GameCoordinator, GameState>(
      builder: (BuildContext context, state, _) {
        if (state != GameState.paused) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              // scaffoldKey.currentState?.openDrawer();
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.star,
              color: Colors.white,
              // size: 30,
            ),
          ),
        );
      },
      selector: (_, game) => game.gameState,
      // child:
    );
  }
}
