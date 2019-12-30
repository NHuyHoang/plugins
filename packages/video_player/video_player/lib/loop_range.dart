import 'package:flutter/material.dart';

class LoopRange {
  Duration upper;
  Duration lower;
  Duration duration;

  LoopRange({this.upper, this.lower}) {
    duration = this.upper - this.lower;
  }
}

class LoopRangeNotifier extends ValueNotifier<LoopRange> {
  LoopRange loopRange;

  LoopRangeNotifier(LoopRange value) : super(value);
}