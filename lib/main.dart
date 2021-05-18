import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WidgetKit Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _methodChannel = MethodChannel('work.hondakenya.flutterWidgetkit/sample');
  var _counter = 0;

  Future<void> _incrementCounter() async {
    // カウンターをインクリメントする
    setState(() {
      _counter++;
    });

    // 更新後のカウンターをshared_preferencesで保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);

    // Swiftのメソッド実行を依頼(通知)する（counterの値を保存する）
    try {
      final result = await _methodChannel.invokeMethod('setCounterForWidgetKit');
      print(result);
    } on PlatformException catch (e) {
      print('${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WidgetKitで遊ぶ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ここの数字がウィジェットに表示されます'),
            Text('$_counter', style: TextStyle(fontSize: 100),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
