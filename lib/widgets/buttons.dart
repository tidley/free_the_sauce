import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonUpload extends ConsumerWidget {
  const ButtonUpload({Key? key}) : super(key: key);

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

class ButtonBox extends ConsumerWidget {
  final String text;
  final Function onpressed;

  const ButtonBox({Key? key, required this.text, required this.onpressed})
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
          child: Text(text)),
    );
  }
}
