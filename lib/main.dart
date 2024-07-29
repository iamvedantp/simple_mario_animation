import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'It\'s a me, Mario!',
      debugShowCheckedModeBanner: false,
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
  static const int jumpCount =
      5; // Change this value to set the number of jumps

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
      duration: const Duration(seconds: 5),
    );

    marioX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 2.0),
      TweenSequenceItem(
          tween: Tween(begin: 0.5, end: 0.5), weight: 3.0), // Stop for jumps
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 2.0),
    ]).animate(animationController);

    List<TweenSequenceItem<double>> marioYSequence = [];
    marioYSequence.add(
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 2.0));
    for (int i = 0; i < jumpCount; i++) {
      marioYSequence.add(TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 0.3 / jumpCount));
      marioYSequence.add(TweenSequenceItem(
          tween: Tween(begin: -1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 0.3 / jumpCount));
    }
    marioYSequence.add(
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 2.0));

    marioY = TweenSequence<double>(marioYSequence).animate(animationController);

    List<TweenSequenceItem<double>> blockYSequence = [];
    blockYSequence.add(
        TweenSequenceItem(tween: Tween(begin: -0.18, end: -0.18), weight: 2.0));
    for (int i = 0; i < jumpCount; i++) {
      blockYSequence.add(TweenSequenceItem(
          tween: Tween(begin: -0.18, end: -0.22), weight: 0.3 / jumpCount));
      blockYSequence.add(TweenSequenceItem(
          tween: Tween(begin: -0.22, end: -0.18), weight: 0.3 / jumpCount));
    }
    blockYSequence.add(
        TweenSequenceItem(tween: Tween(begin: -0.18, end: -0.18), weight: 2.0));

    blockY = TweenSequence<double>(blockYSequence).animate(animationController);

    List<TweenSequenceItem<double>> coinYSequence = [];
    coinYSequence.add(
        TweenSequenceItem(tween: Tween(begin: -0.18, end: -0.18), weight: 2.0));
    for (int i = 0; i < jumpCount; i++) {
      coinYSequence.add(TweenSequenceItem(
          tween: Tween(begin: -0.18, end: -0.32), weight: 0.3 / jumpCount));
      coinYSequence.add(TweenSequenceItem(
          tween: Tween(begin: -0.32, end: -0.18), weight: 0.3 / jumpCount));
    }
    coinYSequence.add(
        TweenSequenceItem(tween: Tween(begin: -0.18, end: -0.18), weight: 2.0));

    coinY = TweenSequence<double>(coinYSequence).animate(animationController);

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
                    "lib/assets/block_1.png",
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
