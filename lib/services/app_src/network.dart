import 'package:able_me/services/app_src/env_service.dart';

mixin class Network {
  static final EnvService _env = EnvService.instance;
  static final String _endpoint = _env.prod;
  final String endpoint = "$_endpoint/";
}
