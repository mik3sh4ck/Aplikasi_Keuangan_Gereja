// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

responsiveText(text, double size, FontWeight fontweight, Color color) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: AutoSizeText(
      text,
      style: GoogleFonts.nunito(
        fontSize: size,
        fontWeight: fontweight,
        color: color,
      ),
      minFontSize: 12,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

responsiveTextNoMax(text, double size, FontWeight fontweight, Color color) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: AutoSizeText(
      text,
      style: GoogleFonts.nunito(
        fontSize: size,
        fontWeight: fontweight,
        color: color,
      ),
      minFontSize: 12,
    ),
  );
}
