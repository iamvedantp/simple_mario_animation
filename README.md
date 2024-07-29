# Mario Animation Demo

This Flutter project demonstrates a simple animation where Mario walks, jumps multiple times, and interacts with a block and a coin. The number of jumps Mario makes is configurable.

## Features

- Mario walks, stops, jumps multiple times, and then continues walking.
- A block and a coin that animate in sync with Mario's jumps.
- Easily configurable jump count.

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- A code editor such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. **Clone the repository:**
   ```sh
   git clone <repository-url>
   cd mario-animation

2. **Install Dependencies**
     flutter pub get
3. **Run the app**
   flutter run

   **Configuration**
You can configure the number of jumps Mario makes by changing the JUMP_COUNT constant in the `MarioAnimationDemoState` class.

 const int JUMP_COUNT = 10;

 Changing the JUMP_COUNT value will update the number of jumps Mario performs in the center of the screen.

**Project Structure**
*main.dart: Contains the main animation logic and UI.
*lib/assets/: Directory for the Mario, block, and coin images used in the animation.

**Assets**
Make sure to place the following images in the lib/assets/ directory:
*mario_1.png
*mario_3.png
*mario_4.png
*mario_5.png
*block_1.png
*block_2.png
*coin.png

**How It Works**
*Mario Animation:

*marioX: Controls Mario's horizontal movement.
*marioY: Controls Mario's vertical movement (jumping).
*blockY and coinY: Control the block and coin's vertical movement.

*Animation Sequences:

*Mario walks to the center, jumps multiple times (based on JUMP_COUNT), then continues walking.
*The block and coin animate in sync with Mario's jumps.

*Frames:

*Mario's frames change based on his actions (walking, stopping, jumping).
*The block's frames change based on its vertical position.

**License**
This project is licensed under the MIT License - see the LICENSE file for details.