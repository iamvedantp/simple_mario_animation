import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'It\'s a me, Mario!',
      home: MarioAnimationDemo(),
    );
  }
}

class MarioAnimationDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MarioAnimationDemoState();
}

class MarioAnimationDemoState extends State<MarioAnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> marioX;
  late Animation<double> marioY;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    marioX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 2.0),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.5), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 2.0),
    ]).animate(animationController);

    marioY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 2.0),
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 0.5),
      TweenSequenceItem(
          tween: Tween(begin: -1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 2.0),
    ]).animate(animationController);

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(
                marioX.value * MediaQuery.of(context).size.width,
                marioY.value * 100,
              ),
              child: const Image(
                image: AssetImage("lib/assets/mario_1.png"),
                width: 50,
                height: 50,
              ),
            ),
          );
        },
      ),
    );
  }
}
