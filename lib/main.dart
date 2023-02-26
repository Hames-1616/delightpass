// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late InAppWebViewController _controller;
//   bool _isLoading = true;
//   List<String> _history = ['https://delightpass.com/app-version'];

//   Future<bool> _onBackPressed() async {
//   if (_history.length > 1) {
//     _history.removeLast();
//     String previousUrl = _history.last;
//     URLRequest request = URLRequest(url: Uri.parse(previousUrl));
//     await _controller.loadUrl(urlRequest: request);
//     return false;
//   } else {
//     String homeUrl = "https://example.com"; // replace with your home URL
//     URLRequest request = URLRequest(url: Uri.parse(homeUrl));
//     await _controller.loadUrl(urlRequest: request);
//     return false;
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: WillPopScope(
//           onWillPop: _onBackPressed,
//           child: Stack(
//             children: [
//               InAppWebView(
//                 initialUrlRequest: URLRequest(
//                     url: Uri.parse('https://delightpass.com/app-version')),
//                 initialOptions: InAppWebViewGroupOptions(
//                   crossPlatform: InAppWebViewOptions(
//                     javaScriptEnabled: true,
//                     useOnDownloadStart: true,
//                     useShouldOverrideUrlLoading: true,
//                   ),
//                 ),
//                 onWebViewCreated: (InAppWebViewController webViewController) {
//                   _controller = webViewController;
//                 },
//                 onLoadStop:
//                     (InAppWebViewController controller, Uri? url) async {
//                   setState(() {
//                     _history.add(url.toString());
//                     _isLoading = false;
//                   });
//                   controller.evaluateJavascript(source: '''
//                       // hide browser controls
//                       document.querySelector('body').style.marginTop = '0px';
//                       document.querySelector('body').style.marginBottom = '0px';
//                       document.querySelector('#browser-controls').style.display = 'none';
//                       // remove the header and footer elements
//                       var header = document.querySelector('header');
//                       if (header != null) {
//                         header.parentNode.removeChild(header);
//                       }
//                       var footer = document.querySelector('footer');
//                       if (footer != null) {
//                         footer.parentNode.removeChild(footer);
//                       }
//                     ''');
//                 },
//                 shouldOverrideUrlLoading: (InAppWebViewController controller,
//                     NavigationAction navigationAction) async {
//                   // allow loading of all URLs
//                   return NavigationActionPolicy.ALLOW;
//                 },
//                 onDownloadStart: (controller, url) async {
//                   // handle downloads here
//                 },
//               ),
//               _isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : Container(),
//             ],
//           ),
//           // _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
 WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
   Future.delayed(Duration(seconds: 2), () {
    // Remove the splash screen and show the home screen
    FlutterNativeSplash.remove();
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool iserror = false;
  String current = "";
  String check = "https://delightpass.com/app-version/index.php";
  late InAppWebViewController _controller;
  bool _isLoading = true;
  List<String> _history = ['https://delightpass.com/app-version'];

  // replace with your home URL
  Future<bool> _onBackPressed() async {
    if (current == check ||
        current == "https://delightpass.com/app-version/login.php") {
      return true;
    } else if (await _controller.canGoBack()) {
      _controller.goBack();
      URLRequest request = URLRequest(
          url: Uri.parse('https://delightpass.com/app-version/index.php'));
      current = check;
      await _controller.loadUrl(urlRequest: request);

      return false;
    } else {
      return true;
    }
  }
  // Future<bool> _onBackPressed() async {

  //   if (_history.length > 1) {
  //      _controller.goBack();
  //     //
  //     // await _controller.loadUrl(urlRequest: request);
  //     return false;
  //   } else {

  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print(current);

    return MaterialApp(
      home: Scaffold(
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse('https://delightpass.com/app-version')),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                    useOnDownloadStart: true,
                    useShouldOverrideUrlLoading: true,
                  ),
                ),
                onWebViewCreated: (InAppWebViewController webViewController) {
                  _controller = webViewController;
                },
                onLoadStop:
                    (InAppWebViewController controller, Uri? url) async {
                  setState(() {
                    current = url.toString();
                    _isLoading = false;
                  });
                  controller.evaluateJavascript(source: '''
                      // hide browser controls
                      document.querySelector('body').style.marginTop = '0px';
                      document.querySelector('body').style.marginBottom = '0px';
                      document.querySelector('#browser-controls').style.display = 'none';
                      // remove the header and footer elements
                      var header = document.querySelector('header');
                      if (header != null) {
                        header.parentNode.removeChild(header);
                      }
                      var footer = document.querySelector('footer');
                      if (footer != null) {
                        footer.parentNode.removeChild(footer);
                      }
                    ''');
                },
                shouldOverrideUrlLoading: (InAppWebViewController controller,
                    NavigationAction navigationAction) async {
                  // allow loading of all URLs
                  return NavigationActionPolicy.ALLOW;
                },
                onDownloadStart: (controller, url) async {
                  // handle downloads here
                },
                onLoadError: ((controller, url, code, message) async {
                  setState(() {
                    iserror = true;
                  });
                }),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(),
              iserror
                  ? Stack(
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                          child: Container(
                            color: Colors.white.withOpacity(0.5),
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Center(
                          child: AlertDialog(
                            title: const Text(
                              'Network Error',
                              style: TextStyle(fontFamily: "Poppins"),
                            ),
                            content: const Text(
                              'Please check your internet connection',
                              style: TextStyle(fontFamily: "Poppins"),
                            ),
                            actions: [
                              Center(
                                child: Container(
                                  // margin: EdgeInsets.only(left: 10,right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: TextButton(
                                    child: const Text(
                                      'Retry',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins"),
                                    ),
                                    onPressed: () {
                                      // _controller.reload();
                                      // setState(() {
                                      //   iserror = false;
                                      // });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  //  Container(
                  //     color: Colors.black38,
                  //     child: Center(
                  //       child: AlertDialog(
                  //         title: const Text('Network Error'),
                  //         content: const Text('Please check your internet connection'),
                  //         actions: [
                  //           TextButton(
                  //             child: const Text('Retry'),
                  //             onPressed: () {
                  //               _controller.reload();
                  //               setState(() {
                  //                 iserror = false;
                  //               });
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
