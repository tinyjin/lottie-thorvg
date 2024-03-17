# Lottie ThorVG for Flutter

This Lottie for Flutter uses [ThorVG](https://github.com/thorvg/thorvg) as a renderer, provides a high performance and compact size.

- 🖼️ Supports Lottie animation (JSON)
- 👑 Based on C++ Native Function
- 🍃 Lower CPU & Memory usage
- ⚡ Higher frame rates

## 🚧 Comming soon
- Built-in DotLottie loader (.lottie)
- Supports C++ multi-threading
- Less application binary size
- Web, MacOS and Windows port


## Benchmark
We've compared `lottie-thorvg` with [lottie-flutter](https://github.com/xvrh/lottie-flutter), we found approximately `+12%` improvement in frame rates.
(single animation in 300x300)

<p align="center">
    <img src="https://raw.githubusercontent.com/tinyjin/lottie-thorvg/main/doc/thorvg_screen.png" width="32%" />
    <img src="https://raw.githubusercontent.com/tinyjin/lottie-thorvg/main/doc/dart_screen.png" width="32%" />
</p>

<p align="center">
    <img src="https://raw.githubusercontent.com/tinyjin/lottie-thorvg/main/doc/thorvg_performance.png" width="32%" />
    <img src="https://raw.githubusercontent.com/tinyjin/lottie-thorvg/main/doc/dart_performance.png" width="32%" />
</p>

There is a significant difference in memory usage profiles; typically, `lottie-thorvg` exhibits lower usage for animations of the same size.

<p align="center">
    <img src="https://raw.githubusercontent.com/tinyjin/lottie-thorvg/main/doc/thorvg_memory.png" width="32%" />
    <img src="https://raw.githubusercontent.com/tinyjin/lottie-thorvg/main/doc/dart_memory.png" width="32%" />
</p>

## Usage

`lottie-thorvg` aims to maintain the same interface as `lottie-flutter`. If you are currently using them, you can utilize the code by simply replacing the import statement with `import 'package:lottie_thorvg/lottie_thorvg.dart'`.

```dart
import 'package:lottie_thorvg/lottie_thorvg.dart';
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

## Known Issues

> [!WARNING]  
> As an experimental project, we anticipate the following issues may render the use of this library unstable. Please verify before using `lottie-thorvg`.

### iOS

#### Unexpected white background rendered ([#2](https://github.com/tinyjin/lottie-thorvg/issues/2))

This seems to be appeared by the Impeller renderer, affecting rendered canvas that has unexpected white background.

**Workaround**:
- Open `Info.plist`
- Turn off Impeller by adding:
  ```plist
  <key>FLTEnableImpeller</key>
  <false/>
  ```

#### Apple Silicon simulator build error ([#4](https://github.com/tinyjin/lottie-thorvg/issues/4))

Currently, ThorVG Flutter iOS binding operates with a dylib. To support universal dynamic library, We should transition to using xcframework. However `dart-ffi` faces an issue where it can't open dynamic libraries through the xcframework.

It only triggers an error when buliding on iOS Simulator under Apple Silicon.

**Workaround**:
- If you're using mac OS(Intel), no effects
- Do use iOS Simulator by rosetta
  It won't effect to real device & store uploading

# License

MIT