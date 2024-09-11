import 'package:example/chopper_api.dart';
import 'package:flutter/material.dart';

Future<void> showDeletePostDialog(
    BuildContext context, ChopperExampleService service) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return DeletePostDialog(
        service: service,
      );
    },
  );
}

class DeletePostDialog extends StatefulWidget {
  const DeletePostDialog({super.key, required this.service});

  final ChopperExampleService service;

  @override
  State<DeletePostDialog> createState() => _DeletePostDialogState();
}

class _DeletePostDialogState extends State<DeletePostDialog> {
  String? id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Post'),
      content: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Post id'),
            onChanged: (value) => id = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            int? maybeId = int.tryParse(id ?? '');

            if (maybeId == null) {
              return;
            }

            widget.service.deletePost(maybeId);
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
