import 'package:flutter/material.dart';

InputDecoration outlinedInputBorder({
  EdgeInsetsGeometry? contentPadding,
  required Color borderColor,
  required Color focusColor,
  required BorderRadius borderRadius
}) {
  return InputDecoration(
    prefixIcon: Icon(
      Icons.search,
      size: 15,
      color: borderColor.withValues(alpha: 0.2),
    ),
    contentPadding: contentPadding,
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
          color: borderColor,
          style: BorderStyle.solid,
          width: 1),
    ),
    border: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
          color: borderColor,
          style: BorderStyle.solid,
          width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
          color: focusColor,
          style: BorderStyle.solid,
          width: 2),
    ),
  );
}