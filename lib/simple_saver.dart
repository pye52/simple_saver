import 'package:simple_saver/save_result.dart';

import 'simple_saver_platform_interface.dart';

class SimpleSaver {
  static Future<SaveResult> saveFile({required String path}) async {
    return SimpleSaverPlatform.instance.saveFile(path: path);
  }
}
