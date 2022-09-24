import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_nft_storage/constants.dart';
import 'package:flutter_nft_storage/providers.dart';
import 'package:flutter_nft_storage/routes/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Custom libs
import 'package:flutter_nft_storage/routes/routes.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<String> apiKey = ref.watch(apiKeyProviderAsync);

    return apiKey.when(
      data: (apiKey) {
        return MaterialApp(
          theme: ThemeData.dark(),
          title: appTitle,
          initialRoute: apiKey == "" ? '/' : '/home',
          routes: {
            '/': (context) => const LoginScreen(),
            '/home': (context) => Home(apiKey: apiKey),
          },
          debugShowCheckedModeBanner: false,
        );
      },
      error: (err, stack) => Text('Error: $err'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
