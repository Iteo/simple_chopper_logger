import 'package:chopper/chopper.dart';
import 'package:example/chopper_api.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({
    required this.client,
    super.key,
  });

  final ChopperClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Stack(
        children: [
          FutureBuilder(
            future: client.getService<ChopperExampleService>().getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final posts = snapshot.data?.body as List?;
                return Scaffold(
                  body: ListView.builder(
                    itemCount: posts?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(posts?[index]['title']),
                        subtitle: Text(posts?[index]['body']),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                client.getService<ChopperExampleService>().postPost(
                  <String, dynamic>{
                    'title': 'foo',
                    'body': 'bar',
                    'userId': 1,
                  },
                );
              },
              child: const Text('Press me'),
            ),
          ),
        ],
      ),
    );
  }
}
