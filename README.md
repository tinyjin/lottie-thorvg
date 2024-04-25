# ThorVG for Flutter

This package provides [ThorVG](https://github.com/thorvg/thorvg) runtime, including efficient Lottie animation support based on a native API.

> Currently, we only support Animation(Lottie) feature in this package.

## Supported Platforms

| Platform | Architecture |
| ------------- | ------------- |
| Android | arm64-v8a, armeabi-v7a, x86_64 |
| iOS | arm64, x86_64, x86_64(simulator) |

## Usage

### Animation
Lottie implementation aims to maintain the same interface as `lottie-flutter`. If you are currently using them, you can utilize the code by simply replacing the import statement with `import 'package:thorvg/thorvg.dart'`.

```dart
import 'package:thorvg/thorvg.dart';
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

## Build

### Android
```sh
cd lottie
sh flutter_build.android.sh
```

Check whether these files are gnerated
- `android/src/main/arm64-v8a/libthorvg.so`
- `android/src/main/armeabi-v7a/libthorvg.so`
- `android/src/main/x86_64/libthorvg.so`

### iOS
```sh
cd lottie
sh flutter_build.ios.sh
```

Check the file is generated
- `ios/Frameworks/libthorvg.dylib`