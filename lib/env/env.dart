import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
    @EnviedField(varName: 'BASE_URL')
    static const String baseurl = _Env.baseurl;

    @EnviedField(varName: 'SECRET_KEY')
    static const String secretkey = _Env.secretkey;

    @EnviedField(varName: 'SUPABASE_URL')
    static const String supabaseUrl = _Env.supabaseUrl;

    @EnviedField(varName: 'SUPABASE_ANON_KEY')
    static const String supabaseAnonKey = _Env.supabaseAnonKey;
}