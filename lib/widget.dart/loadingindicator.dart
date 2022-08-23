import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

loadingIndicator(Color color) {
  return Center(
    child: Column(
      children: [
        LoadingAnimationWidget.staggeredDotsWave(
          size: 100,
          color: color,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Memuat, Tunggu Sebentar ...",
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
