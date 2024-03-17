import 'package:flutter/material.dart';
import 'package:lottie_thorvg/lottie_thorvg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 24);
    const spacerSmall = SizedBox(height: 10);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            // title: const Text('Native Packages'),
            ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 150),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Lottie.asset(
                  'assets/lottie/dancing_star.json',
                  width: 300,
                  height: 300,
                ),
                // Lottie.network(
                //   'https://lottie.host/6d7dd6e2-ab92-4e98-826a-2f8430768886/NGnHQ6brWA.json',
                //   width: 300,
                //   height: 300,
                // ),
                // Lottie.network(
                //   'https://lottie.host/6d7dd6e2-ab92-4e98-826a-2f8430768886/NGnHQ6brWA.json',
                //   width: 300,
                //   height: 300,
                // ),
                const Text(
                  'This calls a universal lottie through FFI that is shipped from the native function powered by ThorVG.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
