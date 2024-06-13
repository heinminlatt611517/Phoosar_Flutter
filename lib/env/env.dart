import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
    @EnviedField(varName: 'BASE_URL')
    static const String baseurl = _Env.baseurl;

    @EnviedField(varName: 'SECRET_KEY')
    static const String secretkey = _Env.secretkey;
    
}