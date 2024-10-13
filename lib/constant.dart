import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

progress(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
            child: LoadingAnimationWidget.halfTriangleDot(
                size: 80, color: Colors.pink),
          ));
}
