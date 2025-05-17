import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accessibility_provider.dart';

class TextScalingWrapper extends StatelessWidget {
  final Widget child;

  const TextScalingWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = context.watch<AccessibilityProvider>().textScaleFactor;
    
    return Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: DefaultTextStyle(
            style: DefaultTextStyle.of(context).style.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
            child: child,
          ),
        );
      },
    );
  }
} 