import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

typedef PushRoute = dynamic Function(String routeName);

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.push}) : super(key: key);

  final PushRoute push;

  @override
  Widget build(BuildContext context) {
    const telHtml = "https://www.qomg.fun/tel.html";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: WebView(
        initialUrl: telHtml,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (request) async {
          final url = request.url;
          debugPrint("url = $url");
          if (request.url == telHtml) {
            return NavigationDecision.navigate;
          }
          if (await canLaunch(url)) {
            launch(url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onWebResourceError: (error) => debugPrint(error.description),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            push("/home");
          } else if (index == 1) {
            push("/product");
          } else if (index == 2) {
            push("/about");
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: '产品',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: '关于',
          ),
        ],
      ),
    );
  }
}
