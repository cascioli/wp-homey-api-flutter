library wp_homey_api;

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/helpers/typedefs.dart';
import '/models/wp_user.dart';
import '/networking/network_manager.dart';

/// The version of the wp_json_api
String _wpHomeyAPIVersion = "1.0.0";

/// The base class to initialize and use WPHomeyAPI
class WPHomeyAPI {
  /// Private constructor for WPHomeyAPI
  WPHomeyAPI._privateConstructor();

  /// Instance of WPHomeyAPI
  static final WPHomeyAPI instance = WPHomeyAPI._privateConstructor();

  /// Instance of Secure Storage
  static FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// The base url for the WordPress Site e.g. https://mysitewp.com
  late String _baseUrl;

  /// Debug boolean for outputting to the log
  bool? _shouldDebug;

  /// Default API root for your WordPress site
  String _apiPath = "/wp-json";

  /// The version
  static String get version => _wpHomeyAPIVersion;

  /// The locale
  static String _currentLocale = 'it';

  /// Initialize and configure class interface.
  /// You can optional set [shouldDebug] == false to stop debugging
  /// [wpJsonPath] is the root path for accessing you sites WordPress APIs
  /// by default this should be "/wp-json".
  init({
    required String baseUrl,
    String wpJsonPath = '/wp-json',
    bool shouldDebug = true,
    String locale = 'it',
  }) {
    _setBaseApi(baseUrl: baseUrl);
    _setApiPath(path: wpJsonPath);
    _setShouldDebug(value: shouldDebug);
    _setLocale(locale);
    _setSecureStorage();
  }

  static void _setLocale(String locale) {
    _currentLocale = locale;
  }

  static void _setSecureStorage() async {
    _secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
  }

  static String get currentLocale => _currentLocale;

  /// Login a user with the [WpUser]
  static wpLogin(WpUser wpUser) async {
    print("Json Encoded: ${jsonEncode(wpUser.toJson())}");

    await _secureStorage.write(
      key: "authLogin",
      value: jsonEncode(wpUser.toJson()),
    );
  }

  /// Logout a user
  static wpLogout() async {
    await _secureStorage.delete(key: "authLogin");
  }

  /// Authenticate a user if they are logged in
  static wpAuth() async {
    final data = await _secureStorage.read(key: "authLogin");
    if (data != null) {
      return WpUser.fromJson(jsonDecode(data));
    }
    return null;
  }

  /// Check if a user is logged in
  static Future<bool> wpUserLoggedIn() async {
    WpUser? _wpUser = await wpUser();
    if (_wpUser == null) {
      return false;
    }
    if (_wpUser.token == null) {
      return false;
    }
    return true;
  }

  /// Returns the logged in user
  static Future<WpUser?> wpUser() async {
    final data = await _secureStorage.read(key: "authLogin");
    if (data == null) {
      return null;
    }
    return WpUser.fromJson(jsonDecode(data));
  }

  /// Returns the user ID of the logged in user
  static Future<String?> wpUserId() async {
    WpUser? _wpUser = await wpUser();
    return _wpUser?.id.toString();
  }

  /// Get the token for the user
  static Future<String?> wpUserToken() async {
    WpUser? _wpUser = await wpUser();
    if (_wpUser == null) return null;
    return _wpUser.token;
  }

  /// Sets the base API in the class
  _setBaseApi({required baseUrl}) {
    this._baseUrl = baseUrl;
  }

  /// Sets the API path in the class
  _setApiPath({required path}) {
    this._apiPath = path;
  }

  /// Sets the debug value in the class
  _setShouldDebug({bool? value}) {
    this._shouldDebug = value;
  }

  /// Returns the debug value
  bool? shouldDebug() {
    return this._shouldDebug;
  }

  /// Returns the base API
  String getBaseApi() {
    return this._baseUrl + this._apiPath;
  }

  /// Returns the base URL
  String getBaseURLOnly() {
    return this._baseUrl;
  }

  /// Returns an instance of [WPAppNetworkManager] which you can use to call
  /// your requests from.
  api(RequestCallback request) async {
    return await request(WPAppNetworkManager.instance);
  }

  /// Returns the storage key for the plugin
  static String storageKey() => "wp_homey_api";
}
