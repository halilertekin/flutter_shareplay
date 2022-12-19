import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shareplay/models/data_model.dart';
import 'package:shareplay/models/participant_model.dart';
import 'package:shareplay/models/session_state_enum.dart';

import 'shareplay_platform_interface.dart';

/// An implementation of [ShareplayPlatform] that uses method channels.
class MethodChannelShareplay extends ShareplayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shareplay');

  @visibleForTesting
  final EventChannel dataChannel = const EventChannel('shareplay/data');

  @override
  Future<bool> start({required String title}) async {
    final result = await methodChannel.invokeMethod<bool>('start', {
      'title': title,
    });
    return result ?? false;
  }

  @override
  Future join() async {
    return methodChannel.invokeMethod('join');
  }

  @override
  Future leave() async {
    return methodChannel.invokeMethod('join');
  }

  @override
  Future end() async {
    return methodChannel.invokeMethod('end');
  }

  @override
  Future<SPParticipant> localParticipant() {
    return methodChannel.invokeMethod('localParticipant').then(
          (value) => SPParticipant.fromMap(
            Map<String, dynamic>.from(value),
          ),
        );
  }

  @override
  Future send(String data) async {
    return methodChannel.invokeMethod('send', {
      'data': data,
    });
  }

  @override
  Future<SPSessionState> sessionState() {
    return methodChannel.invokeMethod<String>('sessionState').then(
          (value) => SPSessionState.values.byName(value ?? 'invalidated'),
        );
  }

  @override
  Stream<SPDataModel> dataStream() {
    return dataChannel.receiveBroadcastStream('dataStream').map(
          (event) => SPDataModel.fromMap(
            Map<String, dynamic>.from(event),
          ),
        );
  }
}
