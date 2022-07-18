import 'package:shared_preferences/shared_preferences.dart';

typedef StoreDecoder<T> = T Function(dynamic data);

class Store {
  static Future<T?> get<T>(String key, {StoreDecoder? decoder}) async {
    final data = (await SharedPreferences.getInstance()).get(key);
    if (data == null) return null;
    if (decoder == null) return data as T;
    return decoder(data) as T;
  }

  static void set(String key, String value) {
    SharedPreferences.getInstance().then((instance) => instance.setString(key, value));
  }

  static Future clear() async {
    (await SharedPreferences.getInstance()).clear();
  }
}

extension StoreToken on Store {
  static void setToken(String token) => Store.set('token', token);

  static Future<String?> getToken() => Store.get('token');
}
