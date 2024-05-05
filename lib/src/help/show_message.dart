
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sixcomputer/src/app.dart';
import 'package:sixcomputer/src/components/custom_checkbox.dart';

class Message {
  static showToast(BuildContext context, String message,
      {int? type, bool? center}) {
    FToast fToast = FToast();
    fToast.init(context);

    Future.delayed(Duration.zero, () async {
      fToast.showToast(
        positionedToastBuilder: (context, child) {
          return Positioned(
            bottom: kBottomNavigationBarHeight + 20,
            width: MediaQuery.of(context).size.width,
            child: child,
          );
        },
        child: SafeArea(
          child:
              CustomMessage(
                  message: message,
                  type: type,
                  center: center,
                  onClose: () {
                    fToast.removeCustomToast();
                  },
                ),
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
      );
    });
  }
}
class CustomMessage extends StatefulWidget {
  final String? message;
  final int? type;
  final bool? center;
  final VoidCallback? onClose;
  const CustomMessage({super.key, this.message, this.type, this.center, this.onClose});

  @override
  State<CustomMessage> createState() => _CustomMessage();
}

class _CustomMessage extends State<CustomMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xff4A4A4A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.9),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  // Image.asset(
                                  //     widget.type == null || widget.type == 1
                                  //         ? 'assets/images/toast_icon.png'
                                  //         : 'assets/images/toast_info.png',
                                  //     width: 20,
                                  //     height: 20),
                                  // SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      widget.message!,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      maxLines: 2,
                                      textAlign: widget.center != null &&
                                              widget.center!
                                          ? TextAlign.center
                                          : TextAlign.left,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     widget.onClose!();
                            //   },
                            //   child: Image.asset('assets/images/icon_close.png',
                            //       width: 20, height: 20, color: Colors.white),
                            // )
                          ],
                        )
                      ]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

  // static showNotificationMessage(String title, String body,
  //     {@required VoidCallback? callback}) {
  //   BotToast.showCustomNotification(
  //       animationDuration: const Duration(milliseconds: 200),
  //       animationReverseDuration: const Duration(milliseconds: 200),
  //       duration: const Duration(seconds: 3),
  //       toastBuilder: (cancel) {
  //         return NotificationMessage(
  //           title: title,
  //           body: body,
  //           type: MessageType.notification,
  //           cancelFunc: () {
  //             callback!();
  //             cancel();
  //           },
  //         );
  //       });
  // }

//   static Future<void> showLocalNotification(NotificationModel model) async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'channel_ID',
//       'channel name',
//       channelDescription: 'channel description',
//       importance: Importance.max,
//       playSound: true,
//       showProgress: true,
//       priority: Priority.high,
//     );

//     var iOSChannelSpecifics =
//         DarwinNotificationDetails(presentAlert: true, presentSound: true);
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
//     if (Platform.isIOS) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()!
//           .requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );
//     }

//     final jsonString = jsonEncode(model.toJson());

//     await flutterLocalNotificationsPlugin.show(
//         0, model.title, model.content, platformChannelSpecifics,
//         payload: jsonString);
//   }
// }

// enum MessageType { success, error, warning, notification }

// class NotificationMessage extends StatefulWidget {
//   final CancelFunc? cancelFunc;
//   final String? title;
//   final String? body;
//   final MessageType? type;

//   const NotificationMessage(
//       {Key? key, this.title, this.body, this.type, this.cancelFunc})
//       : super(key: key);

//   @override
//   State<NotificationMessage> createState() => _NotificationMessage();
// }

// class _NotificationMessage extends State<NotificationMessage> {
//   String icon = 'assets/images/icon_app.png';

//   @override
//   void initState() {
//     super.initState();
//     switch (widget.type) {
//       case MessageType.notification:
//         icon = 'assets/images/icon_app.png';
//         break;
//       case MessageType.success:
//         icon = 'assets/images/icon_success.png';
//         break;
//       case MessageType.error:
//         icon = 'assets/images/icon_error.png';
//         break;
//       case MessageType.warning:
//         icon = 'assets/images/icon_warning.png';
//         break;
//       default:
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 18, right: 18),
//       child: GestureDetector(
//         onTap: widget.cancelFunc,
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       blurRadius: 2,
//                       offset: const Offset(0, 1),
//                     )
//                   ]),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Image.asset(
//                     icon,
//                     width: widget.type == MessageType.notification ? 40 : 26,
//                     height: widget.type == MessageType.notification ? 40 : 26,
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: widget.body!.isEmpty
//                             ? [
//                                 Text(
//                                   widget.title!,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                                   maxLines: 2,
//                                 )
//                               ]
//                             : [
//                                 Text(
//                                   widget.title!,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                                   maxLines: 2,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   widget.body!,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400),
//                                   maxLines: 2,
//                                 )
//                               ]),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


// class BookmarkMessage extends StatelessWidget {
//   final bool isBookmark;
//   final VoidCallback onClose;
//   BookmarkMessage({required this.isBookmark, required this.onClose});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 20, right: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//           color: const Color(0xff4A4A4A),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.9),
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             )
//           ]),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Expanded(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Flexible(
//                           flex: 8,
//                           child: Text(
//                             isBookmark
//                                 ? translate(context, 'job_has_been_saved')
//                                 : translate(context, 'unsaved_this_job'),
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(color: Colors.white, fontSize: 16),
//                             maxLines: 2,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Flexible(
//                             flex: 2,
//                             child: Image.asset('assets/images/check_white.png',
//                                 height: 24))
//                       ],
//                     ),
//                   ),
//                   !isBookmark
//                       ? const SizedBox()
//                       : GestureDetector(
//                           onTap: () {
//                             onClose();
//                             Navigator.popUntil(
//                                 context, (route) => route.isFirst);
//                             DartNotificationCenter.post(
//                                 channel: Const.OPEN_HISTORY, options: 1);
//                           },
//                           child: Container(
//                             color: Colors.transparent,
//                             child: Text(
//                               translate(context, 'view_saved_jobs'),
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: primaryColor,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold),
//                               maxLines: 2,
//                             ),
//                           ),
//                         )
//                 ],
//               )
//             ]),
//           )
//         ],
//       ),
//     );
//   }
// }

Future<bool?> showPopupConfirm(
    {required String title,
    required String description,
    String? text1,
    String? text2,
    bool isOnlyAction = false,
    bool showAgainText = false,
    CustomCheckBoxCallback? callback}) async {
  Widget cancelButton = Expanded(
    child: GestureDetector(
      onTap: () {
        Navigator.of(navigatorKey.currentContext!).pop(false);
      },
      child: Container(
          height: 42,
          //padding: EdgeInsets.only(left: 24, right: 24),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(21)),
          child: const Center(
            child: Text(
                'cancel',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
          )),
    ),
  );

  Widget continueButton = Expanded(
    child: GestureDetector(
      onTap: () {
        Navigator.of(navigatorKey.currentContext!).pop(true);
      },
      child: Container(
          height: 42,
          //padding: EdgeInsets.only(left: 24, right: 24),
          decoration: BoxDecoration(
              color: Colors.redAccent, 
              borderRadius: BorderRadius.circular(21)),
          child: const Center(
            child: Text('ok',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
          )),
    ),
  );

  AlertDialog alert = AlertDialog(
    insetPadding: const EdgeInsets.all(16),
    buttonPadding: const EdgeInsets.all(16),
    title: Text(title,
        style: const TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold, fontSize: 20)),
    content: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(description, style: const TextStyle(fontSize: 16)),
          showAgainText ? CustomCheckBox(callback: callback) : const SizedBox(),
          const SizedBox(height: 32),
          Row(
              children: isOnlyAction
                  ? [continueButton]
                  : [
                      continueButton,
                      cancelButton,
                    ])
        ],
      ),
    ),
  );

  return showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return WillPopScope(onWillPop: () async => false, child: alert);
    },
  );
}

Widget iconLoading() {
  return Image.asset('assets/images/icon_loading.gif', height: 100);
}

showLoading() {
  // CircularProgressIndicator();
  BotToast.showLoading(backgroundColor: Colors.transparent);
  // BotToast.showCustomLoading(toastBuilder: (cancelFunc) {
  //   return iconLoading();
  // });
}
