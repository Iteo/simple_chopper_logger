import 'package:chopper/chopper.dart';
import 'package:example/chopper_api.dart';
import 'package:example/create_post_dialog.dart';
import 'package:example/delete_post_dialog.dart';
import 'package:example/patch_post_dialog.dart';
import 'package:example/update_post_dialog.dart';
import 'package:flutter/material.dart';
import 'package:simple_chopper_logger/simple_chopper_logger.dart';

void main() {
  final chopperClient = ChopperClient(
    baseUrl: Uri.parse('https://jsonplaceholder.typicode.com'),
    services: [
      ChopperExampleService.create(),
    ],
    interceptors: [
      SimpleChopperLogger(
        includeRequestHeaders: true,
        includeRequestBody: true,
        includeResponseHeaders: true,
        includeResponseBody: true,
      ),
    ],
    converter: const JsonConverter(),
  );

  runApp(MyApp(client: chopperClient));
}

class MyApp extends StatefulWidget {
  const MyApp({
    required this.client,
    super.key,
  });

  final ChopperClient client;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic>? posts;

  Future<void> getPosts() async {
    final response =
        await widget.client.getService<ChopperExampleService>().getPosts();
    if (response.isSuccessful) {
      setState(() {
        posts = response.body as List?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: posts == null
            ? const SizedBox()
            : ListView.builder(
                itemCount: posts?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(posts?[index]['title']),
                    subtitle: Text(posts?[index]['body']),
                  );
                },
              ),
        floatingActionButton: Builder(builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: getPosts,
                child: const Text('(GET) Fetch a list of posts'),
              ),
              ElevatedButton(
                onPressed: () async {
                  showCreatePostDialog(context,
                      widget.client.getService<ChopperExampleService>());
                },
                child: const Text('(POST) Create a post'),
              ),
              ElevatedButton(
                onPressed: () async {
                  showUpdatePostDialog(context,
                      widget.client.getService<ChopperExampleService>());
                },
                child: const Text('(PUT) Update a post'),
              ),
              ElevatedButton(
                onPressed: () async {
                  showPatchPostDialog(context,
                      widget.client.getService<ChopperExampleService>());
                },
                child: const Text('(PATCH) Patch a post'),
              ),
              ElevatedButton(
                onPressed: () async {
                  showDeletePostDialog(context,
                      widget.client.getService<ChopperExampleService>());
                },
                child: const Text('(DELETE) Delete a post'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
