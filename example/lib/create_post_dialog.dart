import 'package:example/chopper_api.dart';
import 'package:flutter/material.dart';

Future<void> showCreatePostDialog(
    BuildContext context, ChopperExampleService service) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return CreatePostDialog(
        service: service,
      );
    },
  );
}

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({super.key, required this.service});

  final ChopperExampleService service;

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  String? title;
  String? body;
  String? userId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Post'),
      content: Column(
        children: [
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
            widget.service.createPost(<String, dynamic>{
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
