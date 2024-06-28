import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
    @EnviedField(varName: 'BASE_URL')
    static const String baseurl = _Env.baseurl;

    @EnviedField(varName: 'SECRET_KEY')
    static const String secretkey = _Env.secretkey;

    @EnviedField(varName: 'SUPABASE_BASE_URL')
    static const String supabaseBaseUrl = _Env.supabaseBaseUrl;

    @EnviedField(varName: 'SUPABASE_ANON_DATA_KEY')
    static const String supabaseAnonDataKey = _Env.supabaseAnonDataKey;

    @EnviedField(varName: 'GOOGLE_CLIENT_ID')
    static const String googleClientId = _Env.googleClientId;
}