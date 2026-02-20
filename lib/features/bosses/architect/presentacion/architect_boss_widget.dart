// import 'package:bouncer/core/enums/game_state.dart';
// import 'package:bouncer/features/bosses/architect/presentacion/architect_painter.dart';
// import 'package:bouncer/features/bosses/architect/presentacion/architect_viewmodel.dart';
// import 'package:bouncer/features/game/gameCoordinator.dart';
// import 'package:bouncer/features/game/viewModels/gameScreenViewModel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ArchitectBossWidget extends StatelessWidget {
//   final ArchitectViewModel vm;

//   const ArchitectBossWidget({super.key, required this.vm});

//   @override
//   Widget build(BuildContext context) {
//     return Selector<GameCoordinator, bool>(
//       builder: (_, isBossLevel, __) {
//         return isBossLevel == true
//             ? Positioned(
//                 left: vm.position.dx,
//                 top: vm.position.dy,
//                 child: AnimatedBuilder(
//                   animation: vm,
//                   builder: (_, __) {
//                     return CustomPaint(
//                       painter: ArchitectPainter(
//                         hpRatio: vm.hp,
//                         phase: vm.phase,
//                       ),
//                       size: Size(vm.boss.size, vm.boss.size),
//                     );
//                   },
//                 ),
//               )
//             : Container();
//       },
//       selector: (context, coordinator) => coordinator.isBossLevel,
//     );
//   }
// }
