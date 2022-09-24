import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_nft_storage/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

//
import 'package:flutter_nft_storage/constants.dart';

import 'package:flutter_nft_storage/providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<String> apiKey = ref.watch(apiKeyProviderAsync);

    final TextEditingController apiController = TextEditingController();

    void _login() async {
      FileFuns().writeFile(apiFileNameConst, apiController.text);
      Navigator.pushNamed(
        context,
        '/home',
        arguments: {apiKey: apiController.text},
      );
    }

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
                  child: WideButton(text: 'Login', onpressed: _login),
                ),
                Row(
                  children: <Widget>[
                    TextButton(
                      child: const Text(
                        'New here?',
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
