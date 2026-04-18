import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

class CustomNumberedListStyles {
  const CustomNumberedListStyles._();

  static const String styleKey = 'numbered_list_style';
  static const String decimal = 'decimal';
  static const String alpha = 'alpha';
  static const String roman = 'roman';
}

BlockComponentBuilder buildCustomNumberedListBuilder() {
  return NumberedListBlockComponentBuilder(
    iconBuilder: (context, node, direction) {
      final marker = _markerForNode(node);
      final textStyle = DefaultTextStyle.of(context).style;

      return Container(
        constraints: const BoxConstraints(minWidth: 26, minHeight: 22),
        padding: const EdgeInsets.only(right: 4),
        child: Center(
          child: Text(
            '$marker.',
            textDirection: direction,
            style: textStyle,
          ),
        ),
      );
    },
  );
}

String _markerForNode(Node node) {
  final index = _indexInSameLevel(node);
  final style = _resolveStyle(node);

  switch (style) {
    case CustomNumberedListStyles.alpha:
      return _toLatin(index);
    case CustomNumberedListStyles.roman:
      return _toRoman(index);
    case CustomNumberedListStyles.decimal:
    default:
      return '$index';
  }
}

String _resolveStyle(Node node) {
  final ownStyle = node.attributes[CustomNumberedListStyles.styleKey] as String?;
  if (ownStyle != null && ownStyle.isNotEmpty) {
    return ownStyle;
  }

  Node? previous = node.previous;
  while (previous != null) {
    if (previous.type == NumberedListBlockKeys.type) {
      final previousStyle =
          previous.attributes[CustomNumberedListStyles.styleKey] as String?;
      if (previousStyle != null && previousStyle.isNotEmpty) {
        return previousStyle;
      }
    } else {
      break;
    }
    previous = previous.previous;
  }

  Node? next = node.next;
  while (next != null) {
    if (next.type == NumberedListBlockKeys.type) {
      final nextStyle =
          next.attributes[CustomNumberedListStyles.styleKey] as String?;
      if (nextStyle != null && nextStyle.isNotEmpty) {
        return nextStyle;
      }
    } else {
      break;
    }
    next = next.next;
  }

  return CustomNumberedListStyles.decimal;
}

int _indexInSameLevel(Node node) {
  var level = 1;
  var previous = node.previous;

  if (previous == null || previous.type != NumberedListBlockKeys.type) {
    return node.attributes[NumberedListBlockKeys.number] ?? level;
  }

  int? startNumber;
  while (previous != null && previous.type == NumberedListBlockKeys.type) {
    startNumber = previous.attributes[NumberedListBlockKeys.number] as int?;
    level++;
    previous = previous.previous;
  }

  if (startNumber != null) {
    return startNumber + level - 1;
  }
  return level;
}

String _toLatin(int number) {
  var value = number;
  var result = '';

  while (value > 0) {
    final remainder = (value - 1) % 26;
    result = String.fromCharCode(remainder + 65) + result;
    value = (value - 1) ~/ 26;
  }

  return result.toLowerCase();
}

String _toRoman(int number) {
  final values = <int>[
    1000,
    900,
    500,
    400,
    100,
    90,
    50,
    40,
    10,
    9,
    5,
    4,
    1,
  ];
  final numerals = <String>[
    'm',
    'cm',
    'd',
    'cd',
    'c',
    'xc',
    'l',
    'xl',
    'x',
    'ix',
    'v',
    'iv',
    'i',
  ];

  var value = number;
  final buffer = StringBuffer();

  for (var i = 0; i < values.length; i++) {
    while (value >= values[i]) {
      value -= values[i];
      buffer.write(numerals[i]);
    }
  }

  return buffer.toString();
}
