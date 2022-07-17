import 'package:flutter/material.dart';

class Alerts {
  dynamic checkClear(BuildContext context, _clearList) {
    var editItem = AlertDialog(
      title: const Text('Clear local storage.'),
      content: const Text('Are you sure?'),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        OutlinedButton(
          onPressed: () {
            _clearList();
            Navigator.of(context).pop();
          },
          child: const Text('YES'),
        ),
      ],
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return editItem;
      },
    );
  }
}
