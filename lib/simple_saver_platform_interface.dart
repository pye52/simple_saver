import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:simple_saver/save_result.dart';

import 'simple_saver_method_channel.dart';

abstract class SimpleSaverPlatform extends PlatformInterface {
  /// Constructs a SimpleSaverPlatform.
  SimpleSaverPlatform() : super(token: _token);

  static final Object _token = Object();

  static SimpleSaverPlatform _instance = MethodChannelSimpleSaver();

  /// The default instance of [SimpleSaverPlatform] to use.
  ///
  /// Defaults to [MethodChannelSimpleSaver].
  static SimpleSaverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SimpleSaverPlatform] when
  /// they register themselves.
  static set instance(SimpleSaverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<SaveResult> saveFile({required String path}) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
