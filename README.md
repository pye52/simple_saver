# simple_saver

[![pub package](https://img.shields.io/pub/v/simple_saver.svg)](https://pub.dartlang.org/packages/simple_saver)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://choosealicense.com/licenses/mit/)

simplify the [saver_gallery](https://pub.dev/packages/saver_gallery)

We use the `image_picker` plugin to select images from the Android and iOS image library, but it can't save images to the gallery. This plugin can provide this feature.

## Usage

To use this plugin, add `simple_saver` as a dependency in your pubspec.yaml file. For example:
```yaml
dependencies:
  simple_saver: ^1.0.0
```

## iOS
Your project need create with swift.
Add the following keys to your Info.plist file, located in
<project root>/ios/Runner/Info.plist:
```
<key>NSPhotoLibraryAddUsageDescription</key>
<string>获取相册权限</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>获取相册权限</string>
```

##  Android
You need to ask for storage permission to save an image to the gallery. You can handle the storage permission using [flutter_permission_handler](https://github.com/BaseflowIT/flutter-permission-handler).
AndroidManifest.xml file need to add the following permission:
 ```
     <uses-permission
        android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        tools:ignore="ScopedStorage" />
     <!--  if androidExistNotSave = true -->
     <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />   
 ```

## Example
Access permission(use [permission_handler](https://pub.dev/packages/permission_handler))
``` dart
    bool statuses;
    if (Platform.isAndroid) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;
      statuses =
          sdkInt < 29 ? await Permission.storage.request().isGranted : true;
    } else {
      statuses = await Permission.photosAddOnly.request().isGranted;
    }
   bool statuses = await (Platform.isAndroid
            ? Permission.storage
            : Permission.photosAddOnly)
        .request()
        .isGranted;
```

Saving file(ig: video/others) from the internet
``` dart
_saveVideo() async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/temp.mp4";
    await Dio().download("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", savePath);
    final result = await SimpleSaver.saveFile(path: savePath);
    print(result);
 }
```
