import 'package:flutter/material.dart';

import 'package:flutter_nft_storage/classes/classes.dart';
import 'package:flutter_nft_storage/providers.dart';
import 'package:flutter_nft_storage/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';

class SauceList2 {
  final saucesProvider = Provider<List<Card>>((ref) {
    final sauces = ref.watch(sauceProvider);

    return sauces
        .map(
          (Sauce sauce) => Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(sauce.filename),
                  subtitle: Text(sauce.epoch),
                  onTap: () => {},
                )
              ],
            ),
          ),
        )
        .toList();
  });
}

class SauceList3 {
  final saucesProvider = Provider<Column>(
    (ref) {
      final sauces = ref.watch(sauceProvider);

      return Column(
        children: sauces
            .map(
              (Sauce sauce) => Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(sauce.filename),
                      subtitle: Text(sauce.epoch),
                      onTap: () => {},
                    )
                  ],
                ),
              ),
            )
            .toList(),
      );
    },
  );
}

class SauceList extends ConsumerWidget {
  const SauceList({Key? key}) : super(key: key);

  share(BuildContext context, Sauce sauce) {
    final RenderObject? box = context.findRenderObject();

    Share.share("${sauce.filename} - ${sauce.cid}", subject: sauce.filename);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Sauce> sauces = ref.watch(sauceProvider);
    return ListView(
      reverse: true,
      children: [
        Column(
          children: sauces
              .map(
                (Sauce sauce) => Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(sauce.epoch + " - " + sauce.filename,
                            style: const TextStyle(fontSize: 14)),
                        subtitle: Text(
                          "CID: " + sauce.cid,
                          style: const TextStyle(fontSize: 10),
                        ),
                        onTap: () => share(context, sauce),
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
    // return Column(

    //   children: sauces
    //       .map(
    //         (Sauce sauce) => Card(
    //           child: Column(
    //             children: <Widget>[
    //               ListTile(
    //                 title: Text(sauce.epoch + " - " + sauce.filename,
    //                     style: const TextStyle(fontSize: 14)),
    //                 subtitle: Text(
    //                   "CID: " + sauce.cid,
    //                   style: const TextStyle(fontSize: 10),
    //                 ),
    //                 onTap: () => share(context, sauce),
    //               )
    //             ],
    //           ),
    //         ),
    //       )
    //       .toList(),
    // );
  }
}
