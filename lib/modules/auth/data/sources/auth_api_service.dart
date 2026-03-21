import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_user_model.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST(ApiConstants.login)
  Future<HttpResponse<AuthUserModel>> login(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiConstants.register)
  Future<HttpResponse<bool>> register(
    @Body() Map<String, dynamic> body,
  );
}
