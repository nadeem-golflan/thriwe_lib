import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thriwe_lib/custom_animated.dart';

class ProgressDialogWidget extends StatefulWidget {
  final Widget? child;
  final Function(ProgressDialogWidgetState)? onInIt;
  final String progressMessage;
  final ProgressType progressType;
  final Color? color;

  const ProgressDialogWidget(
      {Key? key,
      this.child,
      this.onInIt,
      this.color = const Color(0xFF388E3C),
      this.progressType = ProgressType.IOS,
      this.progressMessage = "Please wait..."})
      : super(key: key);

  @override
  ProgressDialogWidgetState createState() => ProgressDialogWidgetState();

  static ProgressDialogWidgetState? of(BuildContext context) {
    ProgressDialogWidgetState? progress =
        context.findAncestorStateOfType<ProgressDialogWidgetState>();

    if (progress != null) {
      return progress;
    } else {
      progress = null;
      print(
          'ProgressBarWidget operation requested with a context that does not include a ProgressBarWidget.\n'
          'The context used to show or hide must be that of a '
          'widget that is a descendant of a ProgressBarWidget widget.');
    }
    return progress;
  }
}

enum ProgressType { Android, IOS, BOTH }

class ProgressDialogWidgetState extends State<ProgressDialogWidget> {
  bool isShow = false;
  String progressMessage = "Please wait";
  @override
  void initState() {
    super.initState();
    print("init Progress called");
    isShow = false;
    progressMessage = widget.progressMessage;
    if (widget.onInIt != null) {
      widget.onInIt?.call(this);
    }
  }

  Future show() async {
    setState(() {
      isShow = true;
      animatedShow = true;
    });
  }

  Future hide() async {
    setState(() {
      isShow = false;
      animatedShow = true;
    });
  }

  void setMessage(String message) {
    this.progressMessage = message;
  }

  Widget buildProgressWidget(ProgressType type) {
    if (type == ProgressType.IOS) {
      return _IOSProgressWidget();
    } else if (type == ProgressType.BOTH) {
      if (Platform.isAndroid) {
        return _androidProgressWidget();
      } else if (Platform.isIOS) {
        return _IOSProgressWidget();
      } else {
        return _androidProgressWidget();
      }
    } else {
      return _androidProgressWidget();
    }
  }

  Widget _androidProgressWidget() {
    return Container(
      color: Colors.black.withAlpha(100),
      child: Center(
        child: IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: widget.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    progressMessage,
                    style: TextStyle(fontSize: 14, color: Color(0xff273679)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _IOSProgressWidget() {
    return Container(
      color: Colors.black.withAlpha(100),
      child: Center(
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: widget.color,
                  ),
                  /*  child: CupertinoActivityIndicator(
                    animating: true,
                    radius: 20,
                  ), */
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Text(
                    progressMessage,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool animatedShow = false;
  double opacityValue = 0;

  @override
  Widget build(BuildContext context) {
    print("build Progress called");
    return WillPopScope(
      onWillPop: () {
        return new Future(() => !isShow);
      },
      child: Stack(children: [
        widget.child!,
        CustomAnimatedOpacity(
          opacityResult: (value) {
            opacityValue = value;
            Future.delayed(Duration.zero, () {
              setState(() {});
            });
          },
          opacity: isShow ? 1 : 0,
          duration: Duration(milliseconds: isShow ? 80 : 100),
          child: Visibility(
            visible: opacityValue == 0 ? false : true,
            child: Material(
                color: Colors.transparent,
                child: buildProgressWidget(widget.progressType)),
          ),
        )
      ]),
    );
  }
}
