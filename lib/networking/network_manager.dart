import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import '/exceptions/empty_username_exception.dart';
import '/exceptions/existing_user_email_exception.dart';
import '/exceptions/existing_user_login_exception.dart';
import '/exceptions/incorrect_password_exception.dart';
import '/exceptions/invalid_email_exception.dart';
import '/exceptions/invalid_params_exception.dart';
import '/exceptions/invalid_user_token_exception.dart';
import '/exceptions/invalid_username_exception.dart';
import '/exceptions/user_already_exist_exception.dart';
import '/exceptions/username_taken_exception.dart';
import '/exceptions/woocommerce_not_found_exception.dart';
import '../models/responses/wp_token_verified_response.dart';
import '/models/responses/wp_user_delete_response.dart';
import '/models/responses/wp_user_info_updated_response.dart';
import '/models/responses/wp_user_login_response.dart';
import '/models/responses/wp_user_register_response.dart';
import '/models/responses/wp_user_reset_password_response.dart';
import '/models/wp_meta_meta.dart';
import '/models/wp_user.dart';
import '../wp_homey_api.dart';
import '/enums/wp_route_type.dart';
import '/models/responses/wp_user_info_response.dart';

/// A networking class to manage all the APIs from "wp_homey_api"
class WPAppNetworkManager {
  WPAppNetworkManager._privateConstructor();

  Dio dio = Dio();

  /// An instance of [WPAppNetworkManager] class
  static final WPAppNetworkManager instance =
      WPAppNetworkManager._privateConstructor();

  /// Sends a request to login a user with the [email] & [password]
  /// or [username] and [password]. Set [authType] to auth with email/username.
  ///
  /// Returns a [WPUserLoginResponse] future.
  /// Throws an [InvalidNonceException] if nonce token is not valid
  /// [InvalidEmailException] if the email is not valid
  /// [IncorrectPasswordException] if the password is not valid
  /// [InvalidUsernameException] if the username is not valid
  /// [Exception] for any other reason.
  Future<WPUserLoginResponse> wpLogin(
      {String? username,
      required String password,
      String? tokenExpiryAt,
      bool saveTokenToLocalStorage = true}) async {
    // Creates payload for login
    Map<String, dynamic> payload = {};
    if (username != null) payload["username"] = username;
    payload["password"] = password;
    if (tokenExpiryAt != null) payload["expiry"] = tokenExpiryAt;

    // send http request
    final json = await _http(
      method: "POST",
      url: _urlForRouteType(WPRouteType.AuthLogin),
      body: payload,
    );

    // return response
    if (_jsonHasBadStatus(json)) {
      return _throwExceptionForStatusCode(json);
    }

    WPUserLoginResponse wpUserLoginResponse =
        WPUserLoginResponse.fromJson(json);

    String? userToken = wpUserLoginResponse.data?.userToken;

    if (userToken != null && saveTokenToLocalStorage) {
      WpUser wpUser = WpUser.fromWPUserLoginResponse(wpUserLoginResponse);
      await WPHomeyAPI.wpLogin(wpUser);
    }

    print("wpUserLoginResponseData: $wpUserLoginResponse");
    return wpUserLoginResponse;
  }

  /// Sends a request to register a user in WordPress with the following
  /// parameters [username], [email] and [password].
  /// You can optionally set an [expiry] for the token expiry like "+1 day".
  ///
  /// Returns a [WPUserRegisterResponse] future.
  /// Throws an [UsernameTakenException] if username is taken
  /// [ExistingUserLoginException] if user login exists
  /// [ExistingUserEmailException] if that email is in use
  /// [UserAlreadyExistException] if a user was found with the same email
  /// [EmptyUsernameException] if the username field has empty
  /// [Exception] if fails.
  Future<WPUserRegisterResponse> wpRegister(
      {required String email,
      required String password,
      String? username,
      String? expiry,
      Map<String, dynamic>? args,
      bool saveTokenToLocalStorage = true}) async {
    if (username == null) {
      username = (email.replaceAll(RegExp(r'([@.])'), "")) + _randomString(4);
    }

    // Creates payload for register
    Map<String, dynamic> payload = {
      "email": email,
      "password": password,
      "username": username,
      "args": args
    };
    if (expiry != null) payload["expiry"] = expiry;

    // send http request
    final json = await _http(
      method: "POST",
      url: _urlForRouteType(WPRouteType.UserRegister),
      body: payload,
    );

    // return response
    if (_jsonHasBadStatusUserRegistration(json)) {
      return _throwExceptionForStatusCode(json);
    }
    WPUserRegisterResponse wPUserRegisterResponse =
        WPUserRegisterResponse.fromJson(json);
    String? userToken = wPUserRegisterResponse.data?.userToken;

    if (userToken != null && saveTokenToLocalStorage) {
      WpUser wpUser = WpUser.fromWPUserRegisterResponse(wPUserRegisterResponse);
      await WPHomeyAPI.wpLogin(wpUser);
    }
    return wPUserRegisterResponse;
  }

  /// Sends a request to check if a given [token] value is still valid.
  ///
  /// Returns a [WPTokenVerifiedResponse] future.
  /// Throws an [Exception] if fails
  Future<WPTokenVerifiedResponse> wpAuthValidate({String? token}) async {
    // send http request
    final json = await _http(
      method: "POST",
      url: _urlForRouteType(WPRouteType.AuthValidate),
      userToken: token,
      shouldAuthRequest: true,
    );

    // return response
    return _jsonHasBadStatus(json)
        ? this._throwExceptionForStatusCode(json)
        : WPTokenVerifiedResponse.fromJson(json);
  }

  /// Sends a request to get a users WordPress info using a valid [userToken].
  ///
  ///
  /// Returns a [WPUserInfoResponse] future.
  /// Throws an [Exception] if fails
  Future<WPUserInfoResponse> wpGetUserInfo({String? userToken}) async {
    // send http request
    final json = await _http(
      method: "GET",
      url: _urlForRouteType(WPRouteType.UserInfo),
      userToken: userToken,
      shouldAuthRequest: true,
    );

    // return response
    return _jsonHasBadStatus(json)
        ? this._throwExceptionForStatusCode(json)
        : WPUserInfoResponse.fromJson(json);
  }

  /// Sends a request to update details for a WordPress user. Include a valid
  /// [userToken] to send a successful request. Optional parameters include
  /// a [firstName], [lastName], [displayName] or [metaData] to update user's.
  ///
  /// Returns a [WPUserInfoUpdatedResponse] future.
  /// Throws an [Exception] if fails.
  Future<WPUserInfoUpdatedResponse> wpUpdateUserInfo(
      {String? userToken,
      String? firstName,
      String? lastName,
      String? displayName,
      List<WpMetaData>? metaData}) async {
    Map<String, dynamic> payload = {};
    if (firstName != null) payload["first_name"] = firstName;
    if (lastName != null) payload["last_name"] = lastName;
    if (displayName != null) payload["display_name"] = displayName;
    if (metaData != null) {
      payload['meta_data'] = {
        "items": metaData.map((e) => e.toJson()).toList()
      };
    }

    // send http request
    final json = await _http(
      method: "POST",
      url: _urlForRouteType(WPRouteType.UserUpdateInfo),
      userToken: userToken,
      shouldAuthRequest: true,
      body: payload,
    );

    // return response
    return _jsonHasBadStatus(json)
        ? this._throwExceptionForStatusCode(json)
        : WPUserInfoUpdatedResponse.fromJson(json);
  }

  /// Logs out the user by deleting the user token from the local storage
  wpLogout() async {
    await WPHomeyAPI.wpLogout();
  }

  /// Sends a request to delete a WordPress user. Include a valid
  /// [userToken] and an optional [reassign] argument to send a successful request.
  ///
  /// Returns a [WPUserDeleteResponse] future.
  /// Throws an [Exception] if fails.
  /*Future<WPUserDeleteResponse> wpUserDelete(
      {String? userToken, int? reassign}) async {
    Map<String, dynamic> payload = {};
    if (reassign != null) {
      payload["reassign"] = reassign;
    }

    // send http request
    final json = await _http(
      method: "POST",
      url: _urlForRouteType(WPRouteType.UserDelete),
      userToken: userToken,
      shouldAuthRequest: true,
      body: payload,
    );

    // return response
    return _jsonHasBadStatus(json)
        ? this._throwExceptionForStatusCode(json)
        : WPUserDeleteResponse.fromJson(json);
  }*/

  /// Reset a user password using the [userToken] and new [password] created.
  ///
  /// Returns a [WCCustomerInfoResponse] future.
  /// Throws an [Exception] if fails.
  Future<WPUserResetPasswordResponse> wpResetPassword({
    required String userEmail,
    String? userToken,
  }) async {
    Map<String, dynamic> payload = {"user_login": userEmail};

    // send http request
    final json = await _http(
      method: "POST",
      url: _urlForRouteType(WPRouteType.UserUpdatePassword),
      body: payload,
      userToken: userToken,
      shouldAuthRequest: false,
    );

    // return response
    return _jsonHasBadStatus(json)
        ? this._throwExceptionForStatusCode(json)
        : WPUserResetPasswordResponse.fromJson(json);
  }

  /// Sends a Http request using a valid request [method] and [url] endpoint
  /// from the WP_JSON_API plugin. The [body] and [userToken] is optional but
  /// you can use these if the request requires them.
  ///
  /// Returns a [dynamic] response from the server.
  Future<dynamic> _http({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    String? userToken,
    bool shouldAuthRequest = false,
    bool shouldSendformHeader = false,
  }) async {
    Response? response;
    if (method == "GET") {
      response = await dio.get(url);
    } else if (method == "POST") {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "*/*",
        HttpHeaders.acceptEncodingHeader: "gzip, deflate, br",
      };

      if (shouldSendformHeader) {
        headers[HttpHeaders.contentTypeHeader] =
            "multipart/form-data; charset=UTF-8";
      }

      // Aggiungiamo il token JWT all'header se richiesto
      String? userTokenFromStorage = await WPHomeyAPI.wpUserToken();
      if (shouldAuthRequest && userTokenFromStorage != null) {
        headers['Authorization'] = 'Bearer $userTokenFromStorage';
      }
      if (userToken != null) {
        headers['Authorization'] = 'Bearer $userToken';
      }

      if (body == null) {
        body = {};
      }

      if (body.containsKey("username") && body.containsKey("password")) {
        url =
            url + "?username=${body["username"]}&password=${body["password"]}";
        body = null;
      }

      response = await dio.post(
        url,
        options: Options(headers: headers),
        data: body,
      );
    }

    // log output
    if (response != null) {
      _devLogger(
          url: response.requestOptions.uri.toString(),
          payload: response.requestOptions.data.toString(),
          result: response.data.toString());
    }

    return response?.data;
  }

  /// Logs the output of a app request.
  /// [url] should be set containing the url route for the request.
  /// The [payload] and [result] are optional but are used in the
  /// log output if set. This will only log if shouldDebug is enabled.
  ///
  /// Returns void.
  _devLogger({required String url, String? payload, String? result}) {
    String strOutput = "\nREQUEST: " + url;
    if (payload != null) strOutput += "\nPayload: " + payload;
    if (result != null) strOutput += "\nRESULT: " + result;

    // logs response if shouldDebug is enabled
    if (WPHomeyAPI.instance.shouldDebug()!) log(strOutput);
  }

  /// Checks if a response payload has a bad status (=> 500).
  ///
  /// Returns [bool] true if status is => 500.
  _jsonHasBadStatus(json) {
    if (json["status"] == null) {
      return false;
    }

    return (json["status"] >= 500 ||
        json["code"] == "jwt_auth_invalid_token" ||
        json["status"] == 403);
  }

  /// Checks if a user registration response payload has a bad status (400,401,404).
  ///
  /// Returns [bool] true if status is 400,401,404.
  _jsonHasBadStatusUserRegistration(json) {
    return (json["status"] == 400 ||
        json["status"] == 401 ||
        json["status"] == 404);
  }

  /// Creates an endpoint with the baseUrl and path.
  ///
  /// Returns [String] of the url route.
  String _urlForRouteType(WPRouteType wpRouteType) {
    if (wpRouteType == WPRouteType.UserUpdatePassword) {
      return WPHomeyAPI.instance.getBaseURLOnly() +
          "/wp-login.php?action=lostpassword";
    }

    return WPHomeyAPI.instance.getBaseApi() + _getRouteUrlForType(wpRouteType);
  }

  /// The routes available for the WP_JSON_API plugin
  /// set [wpRouteType] and use optional [apiVersion] to change API version.
  ///
  /// Returns [String] url path for request.
  String _getRouteUrlForType(
    WPRouteType wpRouteType, {
    String apiVersion = 'v2',
    String jwtApiVersion = 'v1',
  }) {
    switch (wpRouteType) {
      // AUTH API
      case WPRouteType.AuthLogin:
        {
          return "/jwt-auth/$jwtApiVersion/token";
        }
      case WPRouteType.AuthValidate:
        {
          return "/jwt-auth/$jwtApiVersion/token/validate";
        }
      // WORDPRESS API
      case WPRouteType.UserRegister:
        {
          return "/wp/$apiVersion/users/register";
        }
      case WPRouteType.UserInfo:
        {
          return "/wp/$apiVersion/users/me";
        }
      case WPRouteType.UserUpdateInfo:
        {
          return "/wp/$apiVersion/users/me";
        }
      /*case WPRouteType.UserUpdatePassword:
        {
          return "/wp/$apiVersion/update/user/password";
        }*/
      /*case WPRouteType.UserDelete:
        {
          return "/wp/$apiVersion/users/me/delete";
        }*/
      default:
        {
          return "";
        }
    }
  }

  /// Generates a random string of [length] characters.
  String _randomString(int length) {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    math.Random rnd = math.Random(DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < length; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  /// Throws an exception from the [json] status returned from payload.
  _throwExceptionForStatusCode(json) {
    if (json != null && json['status'] != null) {
      int? statusCode = json["status"];
      String? code = json["code"];
      String message = json["message"] ?? 'Something went wrong';

      switch (statusCode) {
        case 650:
          throw Exception(message);
        case 651:
          throw Exception(message);
        case 652:
          throw Exception(message);
        case 403:
          switch (code) {
            case 'jwt_auth_invalid_username':
              throw InvalidUsernameException(message);
            case 'jwt_auth_invalid_password':
              throw IncorrectPasswordException(message);
            case 'jwt_auth_invalid_token':
              throw InvalidUserTokenException();
            default:
              throw Exception(message);
          }
        case 520:
          throw new UsernameTakenException();
        case 500:
          throw new Exception(message);
        case 510:
          throw new WooCommerceNotFoundException();
        case 540:
          throw new InvalidUserTokenException();
        case 523:
          throw new InvalidParamsException();
        case 567:
          throw new Exception(message);
        case 547:
          throw new InvalidEmailException(message);
        case 546:
          throw new IncorrectPasswordException(message);
        case 545:
          throw new InvalidUsernameException(message);
        case 531:
          throw new ExistingUserLoginException(message);
        case 532:
          throw new ExistingUserEmailException(message);
        case 527:
          throw new UserAlreadyExistException();
        case 542:
          throw new EmptyUsernameException();
        default:
          {
            throw new Exception(
                'Something went wrong, please check server response');
          }
      }
    }
  }
}
