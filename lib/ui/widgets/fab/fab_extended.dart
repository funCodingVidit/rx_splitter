import 'package:flutter/material.dart';
import 'package:rx_splitter/constants/app_colors.dart';

Widget buildExtendedFAB(VoidCallback onPressed) => AnimatedContainer(
  duration: const Duration(microseconds: 200),
  curve: Curves.linear,
  width: 150,
  height: 50,
  child: FloatingActionButton.extended(
    onPressed: onPressed,
    backgroundColor: AppColors.kGreen,
    icon: const Icon(Icons.event_note_outlined),
    label: const Center(
      child: Text(
        "Add expense",
        style: TextStyle(fontSize: 15, color: AppColors.white),
      ),
    ),
  ),
);