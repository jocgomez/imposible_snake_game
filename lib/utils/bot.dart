import 'package:flutter/material.dart';
import 'package:snake_game/widgets/box_widget.dart';

class PlaceHolderBot extends StatefulWidget {
  const PlaceHolderBot({Key? key}) : super(key: key);

  @override
  State<PlaceHolderBot> createState() => _PlaceHolderBotState();
}

class _PlaceHolderBotState extends State<PlaceHolderBot>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BoxWidget(
      color: Colors.red.withOpacity(animation.value),
    );
  }
}
