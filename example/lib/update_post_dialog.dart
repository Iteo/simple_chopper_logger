import 'package:example/chopper_api.dart';
import 'package:flutter/material.dart';

Future<void> showUpdatePostDialog(
    BuildContext context, ChopperExampleService service) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return UpdatePostDialog(
        service: service,
      );
    },
  );
}

class UpdatePostDialog extends StatefulWidget {
  const UpdatePostDialog({super.key, required this.service});

  final ChopperExampleService service;

  @override
  State<UpdatePostDialog> createState() => _UpdatePostDialogState();
}

class _UpdatePostDialogState extends State<UpdatePostDialog> {
  String? id;
  String? title;
  String? body;
  String? userId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Post'),
      content: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Post id'),
            onChanged: (value) => id = value,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Title'),
            onChanged: (value) => title = value,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Body'),
            onChanged: (value) => body = value,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'User ID'),
            onChanged: (value) => userId = value,
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

            widget.service.updatePost(maybeId, <String, dynamic>{
              'title': title,
              'body': body,
              'userId': userId,
            });
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
