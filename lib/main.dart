import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_stickers/states/shared/_shared.dart';

import 'ui/_ui.dart';
import 'ui_kit/_ui_kit.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isLight = ref.watch(sharedProvider).light;

      return MaterialApp(
        title: 'Sunny Stickers',
        theme: isLight ? AppTheme.lightTheme : AppTheme.darkTheme,
        home: const HomeScreen(),
      );
    });
  }
}
