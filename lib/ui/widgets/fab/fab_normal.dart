import 'package:flutter/material.dart';

Widget buildNormalFAB(VoidCallback onPressed) => AnimatedContainer(
  duration: const Duration(microseconds: 200),
  curve: Curves.linear,
  width: 50,
  height: 50,
  child: FloatingActionButton.extended(
        onPressed: onPressed,
        icon: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.event_note_outlined),
        ),
        label: const SizedBox(),
      ),
);
