import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

//
import 'package:flutter_nft_storage/constants/constants.dart';

import 'package:flutter_nft_storage/providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<String> apiKey = ref.watch(apiKeyProviderAsync);

    final TextEditingController apiController =
        TextEditingController();

    return apiKey.when(
        data: (apiKey) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Sign In'),
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: apiController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'API Key',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        print(apiController.text);
                        apiKey = apiController.text;
                        FileFuns()
                            .writeFile(apiFileNameConst, apiController.text);
                        Navigator.pushNamed(
                          context,
                          '/home',
                          arguments: {apiKey: apiKey},
                        );
                      },
                    )),
                Row(
                  children: <Widget>[
                    const Text(
                      'New here?',
                      style: TextStyle(height: 1.6),
                    ),
                    TextButton(
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () => launch('https://nft.storage/login/'),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          );
        },
        error: (err, stack) => Text('Error: $err'),
        loading: () => const CircularProgressIndicator());
  }
}
