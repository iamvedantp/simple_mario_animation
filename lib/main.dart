import 'package:flutter/animation.dart';
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
  // Add other animations here
  // late Animation<double> marioY;
  // late Animation<int> marioFrame;
  // late Animation<double> blockY;
  // late Animation<int> blockFrame;
  // late Animation<double> coinY;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8));

    List<double> wgts = [1.0, 1.0, 1.0, 1.0, 1.0];

    marioX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: wgts[0]),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.5), weight: wgts[1]),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.5), weight: wgts[2]),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.5), weight: wgts[3]),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: wgts[4]),
    ]).animate(animationController);

    // Start the animation
    animationController.forward();
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
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.translate(
                offset:
                    Offset(marioX.value * MediaQuery.of(context).size.width, 0),
                child: const Image(
                  image: AssetImage("lib/assets/mario_1.png"),
                ),
              );
            },
          ),
          // Add other animated widgets here
        ],
      ),
    );
  }
}
