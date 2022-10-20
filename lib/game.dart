import 'package:flutter/material.dart';
import 'package:snake_game/manager/asset_manager.dart';
import 'package:snake_game/manager/value_manager.dart';
import 'package:snake_game/widgets/box_widget.dart';

import 'model/user.dart';

class Game extends StatefulWidget {
  final User user;
  const Game(this.user, {Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  static int numberOfSquares = 640;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            GridView.builder(
              itemCount: numberOfSquares,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20,
              ),
              itemBuilder: (context, index) {
                return boardSquare();
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _scoreWidget(),
                    _coinsWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Represents an empty board square
  Widget boardSquare() {
    return BoxWidget(
      color: Colors.grey[900]!.withOpacity(.4),
    );
  }

  Widget snakePart() {
    return const BoxWidget(
      color: Colors.orange,
    );
  }

  Widget botPart() {
    return const BoxWidget(
      color: Colors.red,
    );
  }

  Widget foodPart() {
    return const BoxWidget(
      color: Colors.orange,
    );
  }

  Widget coinPart() {
    return BoxWidget(
      color: Colors.yellow,
      child: Image.asset(AssetManager.singleCoin),
    );
  }

  Widget _scoreWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Score: ",
          style: TextStyle(
            color: Colors.white.withOpacity(.5),
            fontSize: ValueManager.v25,
          ),
        ),
        Text(
          "x",
          style: TextStyle(
            color: Colors.white.withOpacity(.5),
            fontSize: ValueManager.v25,
          ),
        ),
      ],
    );
  }

  Widget _coinsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AssetManager.singleCoin,
          width: ValueManager.v25,
        ),
        SizedBox(width: ValueManager.v5),
        Text(
          "x",
          style: TextStyle(
            color: Colors.white.withOpacity(.5),
            fontSize: ValueManager.v25,
          ),
        ),
      ],
    );
  }
}
