import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:simple_saver/save_result.dart';

import 'simple_saver_platform_interface.dart';

/// An implementation of [SimpleSaverPlatform] that uses method channels.
class MethodChannelSimpleSaver extends SimpleSaverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('simple_saver');

  @override
  Future<SaveResult> saveFile({required String path}) async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'saveFile',
      <String, dynamic>{'path': path},
    );
    return SaveResult.fromMap(result!);
  }
}
