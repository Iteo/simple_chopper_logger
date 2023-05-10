import 'package:chopper/chopper.dart';

part 'chopper_api.chopper.dart';

@ChopperApi(baseUrl: '/posts')
abstract class ChopperExampleService extends ChopperService {
  static ChopperExampleService create([ChopperClient? client]) =>
      _$ChopperExampleService(client);

  @Get()
  Future<Response> getPosts();

  @Post()
  Future<Response> postPost(
    @Body() Map<String, dynamic> body,
  );
}
