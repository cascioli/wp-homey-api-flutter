import 'package:flutter/material.dart';
import 'package:wp_homey_api/models/responses/wp_user_info_response.dart';
import 'package:wp_homey_api/models/responses/wp_user_login_response.dart';
import 'package:wp_homey_api/wp_homey_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WooSignal Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WooSignal Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _tfEmailController = TextEditingController();
  TextEditingController _tfPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WPHomeyAPI.instance.init(baseUrl: "http://mysite.com");
  }

  _login() async {
    String email = _tfEmailController.text;
    String password = _tfPasswordController.text;

    WPUserLoginResponse? wpUserLoginResponse;
    // LOGIN
    try {
      wpUserLoginResponse = await WPHomeyAPI.instance.api(
          (request) => request.wpLogin(username: email, password: password));
    } on Exception catch (e) {
      print(e);
    }

    if (wpUserLoginResponse == null) {
      print("invalid login details");
      return;
    }

    print(wpUserLoginResponse.data?.token);
    print(wpUserLoginResponse.data?.id);

    // GET USER INFO
    WPUserInfoResponse? wpUserInfoResponse =
        await WPHomeyAPI.instance.api((request) => request.wpGetUserInfo());

    if (wpUserInfoResponse != null) {
      print(wpUserInfoResponse.data?.firstName);
      print(wpUserInfoResponse.data?.lastName);
    } else {
      print("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _tfEmailController,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _tfPasswordController,
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            MaterialButton(
              child: Text("Login"),
              onPressed: _login,
            )
          ],
        ),
      ),
    );
  }
}
