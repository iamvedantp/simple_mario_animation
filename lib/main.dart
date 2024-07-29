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
  late Animation<double> blockY;
  late Animation<double> coinY;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    marioX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 2.0),
      TweenSequenceItem(
          tween: Tween(begin: 0.5, end: 0.5),
          weight: 1.0), // Stop before jump for 1 second
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 2.0),
    ]).animate(animationController);

    marioY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 3.0),
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

    blockY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -0.18, end: -0.18), weight: 3.0),
      TweenSequenceItem(
          tween: Tween(begin: -0.18, end: -0.22),
          weight: 0.25), // Block jumps up
      TweenSequenceItem(
          tween: Tween(begin: -0.22, end: -0.18),
          weight: 0.25), // Block comes down
      TweenSequenceItem(tween: Tween(begin: -0.18, end: -0.18), weight: 2.0),
    ]).animate(animationController);

    coinY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -0.18, end: -0.18), weight: 3.0),
      TweenSequenceItem(
          tween: Tween(begin: -0.18, end: -0.32),
          weight: 0.25), // Coin jumps higher
      TweenSequenceItem(
          tween: Tween(begin: -0.32, end: -0.18),
          weight: 0.25), // Coin comes down
      TweenSequenceItem(tween: Tween(begin: -0.18, end: -0.18), weight: 2.0),
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
      // Walking before the stop
      return xValue % 0.1 < 0.05 ? 3 : 4;
    } else if (xValue == 0.5 && yValue == 0.0) {
      // Stopping in the center
      return 1;
    } else if (yValue < 0.0) {
      // Jumping
      return 5;
    } else {
      // Walking after the jump
      return xValue % 0.1 < 0.05 ? 3 : 4;
    }
  }

  int getBlockFrame(double yValue) {
    if (yValue < 0.0) {
      return 2; // When block jumps up, change to block_2.png
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    marioX.value *
                        (screenWidth - 80), // Adjust Mario's X position
                    marioY.value * 100,
                  ),
                  child: Image.asset(
                    "lib/assets/mario_$marioFrame.png",
                    gaplessPlayback: true,
                    width: 80, // Increased width
                    height: 80, // Increased height
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: Offset(
                    screenWidth * 0.5 - 15, // Center the coin horizontally
                    screenHeight * coinY.value - 10, // Adjust coin position
                  ),
                  child: Image.asset(
                    "lib/assets/coin.png",
                    gaplessPlayback: true,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: Offset(
                    screenWidth * 0.5 - 25, // Center the block horizontally
                    screenHeight * blockY.value -
                        10, // Adjust block position closer to Mario
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
