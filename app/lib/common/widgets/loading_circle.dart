import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class showCaseLoadingCircle extends StatelessWidget {
  const showCaseLoadingCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitFadingCircle(color: Colors.green, size: 50.0);
  }
}
