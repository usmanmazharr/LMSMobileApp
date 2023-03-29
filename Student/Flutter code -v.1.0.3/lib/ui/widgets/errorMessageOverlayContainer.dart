import 'package:eschool/utils/constants.dart';
import 'package:flutter/material.dart';

class ErrorMessageOverlayContainer extends StatefulWidget {
  final String errorMessage;
  final Color backgroundColor;
  ErrorMessageOverlayContainer(
      {Key? key, required this.errorMessage, required this.backgroundColor})
      : super(key: key);

  @override
  _ErrorMessageOverlayContainerState createState() =>
      _ErrorMessageOverlayContainerState();
}

class _ErrorMessageOverlayContainerState
    extends State<ErrorMessageOverlayContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500))
        ..forward();

  late Animation<double> slideAnimation = Tween<double>(begin: -0.5, end: 1.0)
      .animate(CurvedAnimation(
          parent: animationController, curve: Curves.easeInOutCirc));

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(
            milliseconds: errorMessageDisplayDuration.inMilliseconds - 500),
        () {
      animationController.reverse();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return PositionedDirectional(
          child: Opacity(
            opacity: slideAnimation.value < 0.0 ? 0.0 : slideAnimation.value,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * (0.8),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Text(
                  widget.errorMessage,
                  style: TextStyle(
                      fontSize: 13.5,
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          start: MediaQuery.of(context).size.width * (0.1),
          bottom: MediaQuery.of(context).size.height *
              (0.075) *
              (slideAnimation.value),
        );
      },
    );
  }
}
