import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/game.dart';
import 'package:snake_game/manager/asset_manager.dart';
import 'package:snake_game/manager/value_manager.dart';
import 'package:snake_game/services/route_service.dart';
import 'package:snake_game/services/user_service.dart';
import 'model/user.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RouteService>(
      builder: (context, value, child) {
        if (value.navigateTo == 2) {
          return game(value);
        }
        return menu(value);
      },
    );
  }

  Widget menu(RouteService routeService) {
    final userService = Provider.of<UserService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<User>(
        future: userService.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            User user = snapshot.data!;
            return SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(ValueManager.vd15),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "Highscore: ${user.highScore}",
                          style: const TextStyle(
                            fontSize: ValueManager.vd18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        AssetManager.logo2,
                        width: ValueManager.vd500,
                        height: ValueManager.vd500,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(ValueManager.vd25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _button("START", () => routeService.navigate(2),
                                Colors.amber, const Icon(Icons.play_arrow)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _button(String text, Function() onTap, Color color, Icon icon) {
    return Padding(
      padding: const EdgeInsets.all(ValueManager.vd5),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: icon,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.only(
              left: ValueManager.vd50,
              right: ValueManager.vd50,
              top: ValueManager.vd10,
              bottom: ValueManager.vd10,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ValueManager.vd15),
            ),
          ),
        ),
        label: Text(
          text,
          style: const TextStyle(fontSize: ValueManager.vd22),
        ),
      ),
    );
  }

  Widget game(RouteService routeService) {
    final userService = Provider.of<UserService>(context, listen: false);

    return FutureBuilder<User>(
      future: userService.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          User user = snapshot.data!; // can't be null
          return Game(user);
        }
        return Container();
      },
    );
  }
}
