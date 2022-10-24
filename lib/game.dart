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
  static int numberOfSquares = 640;
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
      direction: directions[direction],
      coins: 0,
      diamonds: 0,
      price: 0,
      score: 0,
      positions: generateRandomPositionList(
        directions[direction],
        positioni,
        5,
      ),
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
      updateGame();
    });
  }

  updateGame() {
    /* checkToSpawnBot();
    if (bots.isNotEmpty) {
      moveBots();
    } */

    setState(() {
      moveSnake();
      detectCollision();
    });
  }

  checkToSpawnBot() {
    if (snake.score >= 20 && bots.isEmpty && placeHolderBots.isEmpty) {
      spawnBots();
    }
    if (snake.score >= 50 && bots.length == 1 && placeHolderBots.isEmpty) {
      spawnBots();
    }
  }

  spawnBots() {
    var direction = random.nextInt(3);
    var position = random.nextInt(botRange);
    var positions =
        generateRandomPositionList(directions[direction], position, 5);
    Snake bot1 = Snake(
        name: "bot 1",
        color: Colors.red,
        direction: directions[direction],
        score: 0,
        positions: positions);
    setState(() {
      placeHolderBots.add(bot1);
    });
    Future.delayed(
        const Duration(seconds: 3),
        () => setState(() {
              placeHolderBots.remove(bot1);
              bots.add(bot1);
            }));
  }

  moveBots() {
    for (var i in bots) {
      switch (i.direction) {
        case "down":
          if (i.positions.last > numberOfSquares - 20) {
            i.positions.add(i.positions.last + 20 - numberOfSquares);
          } else {
            i.positions.add(i.positions.last + 20);
          }
          break;
        case "up":
          if (i.positions.last < 20) {
            i.positions.add(i.positions.last - 20 + numberOfSquares);
          } else {
            i.positions.add(i.positions.last - 20);
          }
          break;
        case "left":
          if (i.positions.last % 20 == 0) {
            i.positions.add(i.positions.last - 1 + 20);
          } else {
            i.positions.add(i.positions.last - 1);
          }
          break;
        case "right":
          if ((i.positions.last + 1) % 20 == 0) {
            i.positions.add(i.positions.last + 1 - 20);
          } else {
            i.positions.add(i.positions.last + 1);
          }
          break;
        default:
      }
      i.positions.removeAt(0);
    }
  }

  moveSnake() {
    switch (snake.direction) {
      case "down":
        // LAST ROW OF GRIDS
        if (snake.positions.last > numberOfSquares - 20) {
          snake.positions.add(snake.positions.last + 20 - numberOfSquares);
        } else {
          snake.positions.add(snake.positions.last + 20);
        }
        break;
      case "up":
        if (snake.positions.last < 20) {
          snake.positions.add(snake.positions.last - 20 + numberOfSquares);
        } else {
          snake.positions.add(snake.positions.last - 20);
        }
        break;
      case "left":
        if (snake.positions.last % 20 == 0) {
          snake.positions.add(snake.positions.last - 1 + 20);
        } else {
          snake.positions.add(snake.positions.last - 1);
        }
        break;
      case "right":
        if ((snake.positions.last + 1) % 20 == 0) {
          snake.positions.add(snake.positions.last + 1 - 20);
        } else {
          snake.positions.add(snake.positions.last + 1);
        }
        break;
      default:
        snake.positions.removeAt(0);
    }
  }

  detectCollision() {
    if (snake.positions.last == coin) {
      snake.coins += 50;
      coin = randomCoin.nextInt(foodRange);
    } else if (snake.positions.last == food) {
      snake.score += 20;
      food = random.nextInt(foodRange);
    } else {
      snake.positions.removeAt(0);
    }
  }

  /// It takes a direction, an initial position and a snake length and returns a list of positions that
  /// the snake will occupy
  ///
  /// Args:
  ///   direction (String): The direction in which the snake is moving.
  ///   initialPosition (int): The initial position of the snake's head.
  ///   snakeLength (int): The length of the snake.
  ///
  /// Returns:
  ///   A list of integers.
  generateRandomPositionList(
    String direction,
    int initialPosition,
    int snakeLength,
  ) {
    List<int> positionsList = [];
    positionsList.add(initialPosition);
    for (var i = 0; i < snakeLength - 1; i++) {
      switch (direction) {
        case "down":
          if (positionsList.last > numberOfSquares - 20) {
            positionsList.add(positionsList.last + 20 - numberOfSquares);
          } else {
            positionsList.add(positionsList.last + 20);
          }
          break;
        case "up":
          if (positionsList.last < 20) {
            positionsList.add(positionsList.last - 20 + numberOfSquares);
          } else {
            positionsList.add(positionsList.last - 20);
          }
          break;
        case "left":
          if (positionsList.last % 20 == 0) {
            positionsList.add(positionsList.last - 1 + 20);
          } else {
            positionsList.add(positionsList.last - 1);
          }
          break;
        case "right":
          if ((positionsList.last + 1) % 20 == 0) {
            positionsList.add(positionsList.last + 1 - 20);
          } else {
            positionsList.add(positionsList.last + 1);
          }
          break;
        default:
      }
    }
    return positionsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (snake.direction != "up" && details.delta.dy > 0) {
                  snake.direction = "down";
                } else if (snake.direction != "down" && details.delta.dy < 0) {
                  snake.direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (snake.direction != "left" && details.delta.dx > 0) {
                  snake.direction = "right";
                } else if (snake.direction != "right" && details.delta.dx < 0) {
                  snake.direction = "left";
                }
              },
              child: GridView.builder(
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
          snake.score.toString(),
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
          snake.coins.toString(),
          style: TextStyle(
            color: Colors.white.withOpacity(.5),
            fontSize: ValueManager.vd25,
          ),
        ),
      ],
    );
  }
}
