import 'package:flutter/material.dart';

import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_nft_storage/providers.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';

class SauceList extends ConsumerWidget {
  const SauceList({Key? key}) : super(key: key);

  share(BuildContext context, Sauce sauce) {
    Share.share("${sauce.filename} - ${sauce.cid}", subject: sauce.filename);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Sauce> sauces = ref.watch(sauceProvider).reversed.toList();
    return Column(
      children: sauces
          .map(
            (Sauce sauce) => Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(sauce.filename,
                        style: const TextStyle(fontSize: 14)),
                    subtitle: Text(
                      'Uploaded: ' + sauce.epoch,
                      style: const TextStyle(fontSize: 11),
                    ),
                    onTap: () => share(context, sauce),
                  )
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
