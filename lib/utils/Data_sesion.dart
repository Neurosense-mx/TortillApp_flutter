import 'package:shared_preferences/shared_preferences.dart';

class DataUser {
  // Instancia singleton
  static final DataUser _instance = DataUser._internal();
  
  // Factory constructor para retornar siempre la misma instancia
  factory DataUser() => _instance;
  
  // Constructor interno privado
  DataUser._internal();
  
  // Keys para SharedPreferences
  static const String _keyIdCuenta = 'id_cuenta';
  static const String _keyIdSucursal = 'id_sucursal';
  static const String _keyIdAdmin = 'id_admin';
  static const String _keyToken = 'token';
  //id negocio
  static const String _keyIdNegocio = 'id_negocio';
  
  // Método para inicializar SharedPreferences (se llama una sola vez)
  Future<SharedPreferences> get _prefs async => 
      await SharedPreferences.getInstance();
  
  // Métodos para guardar datos
  Future<void> setCuenta({
    required int idCuenta,
    required int idSucursal,
    required int idAdmin,

    required String token,
    required int idNegocio,
  }) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyIdCuenta, idCuenta);
    await prefs.setInt(_keyIdSucursal, idSucursal);
    await prefs.setInt(_keyIdAdmin, idAdmin);
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyIdNegocio, idNegocio);
  }
  
  // Métodos para recuperar datos
  Future<int> get idCuenta async {
    final prefs = await _prefs;
    return prefs.getInt(_keyIdCuenta) ?? 0;
  }
  
  Future<int> get idSucursal async {
    final prefs = await _prefs;
    return prefs.getInt(_keyIdSucursal) ?? 0;
  }
  
  Future<int> get idAdmin async {
    final prefs = await _prefs;
    return prefs.getInt(_keyIdAdmin) ?? 0;
  }
  
  Future<String> get token async {
    final prefs = await _prefs;
    return prefs.getString(_keyToken) ?? '';
  }
  Future<int> get idNegocio async {
    final prefs = await _prefs;
    return prefs.getInt(_keyIdNegocio) ?? 0;
  }
  
  // Método para limpiar los datos (logout)
  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_keyIdCuenta);
    await prefs.remove(_keyIdSucursal);
    await prefs.remove(_keyIdAdmin);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyIdNegocio);
  }
}