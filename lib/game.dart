import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/manager/asset_manager.dart';
import 'package:snake_game/manager/value_manager.dart';
import 'package:snake_game/model/board.dart';
import 'package:snake_game/model/snake.dart';
import 'package:snake_game/widgets/box_widget.dart';

import 'model/user.dart';

class Game extends StatefulWidget {
  final User user;
  const Game(this.user, {Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  static int numberOfSquares = ValueManager.numberOfSquares;
  static int foodRange = numberOfSquares - 50;
  static int botRange = numberOfSquares - 50;
  // Initialize snake with positions, name, color and score of 0
  late Snake snake;
  late Board board;
  late Timer timer;

  List<Snake> bots = [];
  List<Snake> placeHolderBots = [];
  List<String> directions = ["up", "down", "left", "right"];

  // ignore: prefer_typing_uninitialized_variables
  var food;
  // ignore: prefer_typing_uninitialized_variables
  var coin;
  // ignore: prefer_typing_uninitialized_variables
  static var random;
  // ignore: prefer_typing_uninitialized_variables
  static var randomCoin;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  startGame() {
    // Reset any active bots
    resetBots();
    // Initialize the snake and board
    initializeModels();
    // Initialize any random vars
    initalizeRandoms();
    // Initialize the food and coin items
    initializeItems();
    // start the game loop
    initializeGameLoop();
    // Game loop
  }

  resetBots() {
    placeHolderBots = [];
    bots = [];
  }

  initializeModels() {
    board = Board(
      id: "default",
      color: Colors.black,
      name: "default",
      price: 0,
    );

    Random rand = Random();
    final direction = rand.nextInt(3);
    final positioni = rand.nextInt(botRange);

    snake = Snake(
      name: "default",
      color: Colors.orange,
      direction: "left",
      coins: 0,
      diamonds: 0,
      price: 0,
      score: 0,
      positions: [41, 42, 43, 44, 45],
    );
  }

  initalizeRandoms() {
    random = Random();
    randomCoin = Random();
  }

  initializeItems() {
    food = random.nextInt(foodRange);
    coin = randomCoin.nextInt(foodRange);
  }

  initializeGameLoop() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // TODO: update the game
    });
  }

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
                crossAxisCount: ValueManager.vi20,
              ),
              itemBuilder: (context, index) {
                if (snake.positions.contains(index)) {
                  return snakePart();
                } else if (food == index) {
                  return foodPart();
                } else if (coin == index) {
                  return coinPart();
                } else {
                  for (var i = 0; i < bots.length; i++) {
                    if (bots[i].positions.contains(index)) {
                      return botPart();
                    }
                  }
                }

                return boardSquare();
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(ValueManager.vd15),
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
            fontSize: ValueManager.vd25,
          ),
        ),
        Text(
          "x",
          style: TextStyle(
            color: Colors.white.withOpacity(.5),
            fontSize: ValueManager.vd25,
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
          width: ValueManager.vd25,
        ),
        const SizedBox(width: ValueManager.vd5),
        Text(
          "x",
          style: TextStyle(
            color: Colors.white.withOpacity(.5),
            fontSize: ValueManager.vd25,
          ),
        ),
      ],
    );
  }
}
