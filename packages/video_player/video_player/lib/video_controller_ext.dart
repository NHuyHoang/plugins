import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/loop_range.dart';
import 'video_player.dart';
///-----
enum PlayerState { play, pause, loop }
///-----
class PlayerStateNotifier extends ValueNotifier<PlayerState> {
  ///
  PlayerState prevState;
  ///
  PlayerStateNotifier(PlayerState value) : super(value) {
    prevState = value;
  }

  set value(PlayerState newValue) {
    prevState = value;
    super.value = newValue;
  }
}

///
class VideoPlayerControllerExt extends VideoPlayerController {
  LoopRangeNotifier _loopRange = LoopRangeNotifier(null);
  LoopRangeNotifier get loopRange => _loopRange;

  ///
  VideoPlayerControllerExt.asset(String dataSource) : super.asset(dataSource);

  ///
  VideoPlayerControllerExt.file(File file) : super.file(file);

  PlayerStateNotifier playerState = PlayerStateNotifier(PlayerState.pause);

  Future<void> play() async {
    if (playerState.value == PlayerState.loop) this.unLoop();

    ///
    await super.play();
    playerState.value = PlayerState.play;
  }

  Future<void> pause() async {
    await super.pause();
    print('video is pausing');
    playerState.value = PlayerState.pause;
  }

  /// loop extension method
  loop(Duration loopDuration, {Duration to}) {
    Duration currentPosition = to != null ? to : value.position;
    Duration lower = currentPosition;
    // ..durationLerp(lower: Duration.zero);
    Duration upper = (currentPosition +
        loopDuration); // .durationLerp(upper: value.duration);
    _loopRange.value = LoopRange(upper: upper, lower: lower);
    print("_loopRange ${_loopRange.value.upper} -> ${_loopRange.value.lower}");
    addListener(_setLoop);
    super.play().then((_) {
      playerState.value = PlayerState.loop;
    });
  }

  _setLoop() {
    if (value.position >= _loopRange.value.upper) {
      seekTo(_loopRange.value.lower);
    }
  }
  ///
  unLoop() {
    removeListener(_setLoop);
    _loopRange.value = null;
    pause();
  }

  /// get process percentage
  double get percent {
    return lerpDouble(0, 1,
        value.position.inMilliseconds / super.value.duration.inMilliseconds);
  }
}
