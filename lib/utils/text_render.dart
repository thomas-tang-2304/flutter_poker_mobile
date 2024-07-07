import 'package:flame/components.dart';
import 'package:flutter/material.dart';

final regular = TextPaint(
    style: const TextStyle(
        color: Color.fromARGB(255, 158, 122, 13),
        fontSize: 25.0, // Change the font size here
        fontWeight: FontWeight.w700,
        letterSpacing: 3,
        fontFamily: 'TitilliumWeb Bold'));

final firstBetRegular = TextPaint(
    style: const TextStyle(
        color: Color.fromARGB(255, 97, 190, 60),
        fontSize: 45.0, // Change the font size here
        fontWeight: FontWeight.w700,
        letterSpacing: 4,
        fontFamily: 'TitilliumWeb Bold'));
final roomCodeRegular = TextPaint(
    style: const TextStyle(
        color: Color.fromARGB(255, 242, 177, 153),
        fontSize: 65.0, // Change the font size here
        fontWeight: FontWeight.w700,
        letterSpacing: 3,
        fontFamily: 'TitilliumWeb Bold'));

// ignore: non_constant_identifier_names
final chip_currency_regular = TextPaint(
    style: const TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 50.0, // Change the font size here
        fontWeight: FontWeight.w700,
        fontFamily: 'TitilliumWeb Bold'));

// ignore: non_constant_identifier_names
final popup_regular = TextPaint(
    style: const TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontSize: 20.0, // Change the font size here
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
        shadows: <Shadow>[
          Shadow(
            blurRadius: 10.0,
            color: Color.fromARGB(255, 246, 242, 242),
          ),
        ],
        fontFamily: 'TitilliumWeb Bold'));

// ignore: non_constant_identifier_names
final home_button_regular = TextPaint(
    style: const TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontSize: 90.0, // Change the font size here
        fontWeight: FontWeight.w700,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 10.0,
            color: Color.fromARGB(255, 246, 242, 242),
          ),
        ],
        fontFamily: 'TitilliumWeb Bold'));
