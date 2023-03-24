import Flutter
import UIKit
import Photos

public class SwiftSimpleSaverPlugin: NSObject, FlutterPlugin {
  let errorMessage = "Failed to save, please check whether the permission is enabled"

    var result: FlutterResult?;

    public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: "simple_saver", binaryMessenger: registrar.messenger())
      let instance = SwiftSimpleSaverPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
    }

      public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        if (call.method == "saveFile") {
          guard let arguments = call.arguments as? [String: Any],
                let path = arguments["path"] as? String
                else { return }
          if (isImageFile(filename: path)) {
              saveImage(path)
          } else {
              if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
                  saveVideo(path)
              }
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      }

      func saveVideo(_ path: String) {
          var videoIds: [String] = []

          PHPhotoLibrary.shared().performChanges( {
              let req = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL.init(fileURLWithPath: path))
              if let videoId = req?.placeholderForCreatedAsset?.localIdentifier {
                  videoIds.append(videoId)
              }
          }, completionHandler: { [unowned self] (success, error) in
              DispatchQueue.main.async {
                  if (success && videoIds.count > 0) {
                      self.saveResult(isSuccess: true)
                  } else {
                      self.saveResult(isSuccess: false, error: self.errorMessage)
                  }
              }
          })
      }

      func saveImage(_ url: String) {

          var imageIds: [String] = []

          PHPhotoLibrary.shared().performChanges( {
              let req = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(string: url)!)
              if let imageId = req?.placeholderForCreatedAsset?.localIdentifier {
                  imageIds.append(imageId)
              }
          }, completionHandler: { [unowned self] (success, error) in
              DispatchQueue.main.async {
                  if (success && imageIds.count > 0) {
                      self.saveResult(isSuccess: true)
                  } else {
                      self.saveResult(isSuccess: false, error: self.errorMessage)
                  }
              }
          })
      }

      /// finish saving，if has error，parameters error will not nill
      @objc func didFinishSavingImage(image: UIImage, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
          saveResult(isSuccess: error == nil, error: error?.description)
      }

      @objc func didFinishSavingVideo(videoPath: String, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
          saveResult(isSuccess: error == nil, error: error?.description)
      }

      func saveResult(isSuccess: Bool, error: String? = nil) {
          var saveResult = SaveResultModel()
          saveResult.isSuccess = error == nil
          saveResult.errorMessage = error?.description
          result?(saveResult.toDic())
      }

      func isImageFile(filename: String) -> Bool {
          return filename.hasSuffix(".jpg")
              || filename.hasSuffix(".png")
              || filename.hasSuffix(".jpeg")
              || filename.hasSuffix(".JPEG")
              || filename.hasSuffix(".JPG")
              || filename.hasSuffix(".PNG")
              || filename.hasSuffix(".gif")
              || filename.hasSuffix(".GIF")
              || filename.hasSuffix(".heic")
              || filename.hasSuffix(".HEIC")
      }
}

public struct SaveResultModel: Encodable {
    var isSuccess: Bool!
    var errorMessage: String?

    func toDic() -> [String:Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        if (!JSONSerialization.isValidJSONObject(data)) {
            return try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
        }
        return nil
    }
}
