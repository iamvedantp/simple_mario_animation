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
      duration: const Duration(seconds: 4),
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

  int getMarioFrame(double xValue, double yValue) {
    if (xValue < 0.5) {
      // Walking before the jump
      return xValue % 0.1 < 0.05 ? 3 : 4;
    } else if (xValue > 0.5) {
      // Walking after the jump
      return xValue % 0.1 < 0.05 ? 3 : 4;
    } else if (yValue < 0.0) {
      // Jumping
      return 5;
    } else {
      // Stopping in the center
      return 1;
    }
  }

  int getBlockFrame(double yValue) {
    if (yValue == -1.0) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          int marioFrame = getMarioFrame(marioX.value, marioY.value);
          int blockFrame = getBlockFrame(marioY.value);

          return Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: Offset(
                    marioX.value * MediaQuery.of(context).size.width,
                    marioY.value * 100,
                  ),
                  child: Image.asset(
                    "lib/assets/mario_$marioFrame.png",
                    gaplessPlayback: true,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: Offset(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height *
                        -0.19, // Adjust block position
                  ),
                  child: Image.asset(
                    "lib/assets/block_$blockFrame.png",
                    gaplessPlayback: true,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
