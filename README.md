# Lottie ThorVG for Flutter

This Lottie for Flutter uses [ThorVG](https://github.com/thorvg/thorvg) as a renderer, provides a high performance and compact size.

- 🖼️ Supports Lottie animation (JSON)
- 👑 Based on C++ Native Function
- 🍃 Lower CPU & Memory usage
- ⚡ Higher frame rates

## 🚧 Comming soon
- Built-in DotLottie loader (.lottie)
- Supports C++ multi-threading
- Less binary size
- Web, MacOS and Windows port


## Benchmark
We've compared lottie-thorvg with lottie-flutter by xvrh, we found approximately `+12%` improvement in frame rates of single animation.

<p align="center">
    <img src="./docs/thorvg_screen.png" width="32%" />
    <img src="./docs/dart_screen.png" width="32%" />
</p>

<p align="center">
    <img src="./docs/thorvg_performance.png" width="32%" />
    <img src="./docs/dart_performance.png" width="32%" />
</p>

## Usage

`lottie-thorvg` aims to maintain the same interface as `lottie-flutter`. If you are currently using `lottie-flutter`, you can utilize the code by simply replacing the import statement with `import 'package:lottie/lottie.dart'`.

```dart
import 'package:lottie_thorvg/lottie.dart';
// ...
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // Load a Lottie animation from the assets
            Lottie.asset('assets/lottie/dancing_star.json'),

            // Load a Lottie animation from a url
            Lottie.network(
              'https://lottie.host/6d7dd6e2-ab92-4e98-826a-2f8430768886/NGnHQ6brWA.json'
            ),
          ],
        ),
      ),
    );
  }
}
```

# License

MIT