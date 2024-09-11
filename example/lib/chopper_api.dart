import 'package:chopper/chopper.dart';

part 'chopper_api.chopper.dart';

@ChopperApi(baseUrl: '/posts')
abstract class ChopperExampleService extends ChopperService {
  static ChopperExampleService create([ChopperClient? client]) =>
      _$ChopperExampleService(client);

  @Get()
  Future<Response> getPosts();

  @Post()
  Future<Response> createPost(@Body() Map<String, dynamic> body);

  @Put(path: '/{id}')
  Future<Response> updatePost(
      @Path('id') int id, @Body() Map<String, dynamic> body);

  @Patch(path: '/{id}')
  Future<Response> patchPost(
      @Path('id') int id, @Body() Map<String, dynamic> body);

  @Delete(path: '/{id}')
  Future<Response> deletePost(@Path('id') int id);
}
