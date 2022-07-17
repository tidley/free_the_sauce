import 'package:flutter/material.dart';
import 'package:flutter_nft_storage/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenButtons extends ConsumerWidget {
  const ScreenButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () => {},
      tooltip: 'Upload',
      child: const Icon(Icons.upload),
    );
  }
}

class WideButton extends ConsumerWidget {
  final String text;
  final Function onpressed;

  const WideButton({Key? key, required this.text, required this.onpressed})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 50,
      ),
      child: ElevatedButton(
          onPressed: () {
            onpressed();
          },
        child: Text(
          text,
          style: btnText,
        ),
      ),
    );
  }
}
