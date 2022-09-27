import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

loadingIndicator() {
  return Center(
    child: Lottie.asset(
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        "lib/assets/lotties/loading_animation.json"),
  );
}

noData() {
  return Center(
    child: Lottie.asset(
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        "lib/assets/lotties/no_data.json"),
  );
}
