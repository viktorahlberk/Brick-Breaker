import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:bouncer/screens/gameScreen.dart';

class Player extends StatelessWidget {
  var x;
  var y;
  var playerWidth;

  Player({super.key, this.x, this.y, this.playerWidth});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * x + playerWidth) / (2 - playerWidth), 0.9),

      // color: Colors.blue,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
          // alignment: Alignment((x*2/100)/2-width/100, 0.9),
          height: 5,
          width: MediaQuery.of(context).size.width * playerWidth / 2,
          color: Colors.white,
        ),
      ),
    );
  }
}
