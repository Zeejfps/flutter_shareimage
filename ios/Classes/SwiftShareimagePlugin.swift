import Flutter
import UIKit
    
public class SwiftShareimagePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins/shareimage", binaryMessenger: registrar.messenger())
    let instance = SwiftShareimagePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "share") {
        let controller = UIApplication.shared.keyWindow?.rootViewController;
        let args = call.arguments as! Dictionary<String, String>;
        let path = args["path"];
        //let image = UIImage(contentsOfFile: path ?? "");
        let image = NSData(contentsOfFile: path ?? "");
        //let imageToShare = [ image! ];
        let activityViewController = UIActivityViewController(activityItems: [ image! ], applicationActivities: nil);
        activityViewController.popoverPresentationController?.sourceView = controller?.view; // so that iPads won't crash
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop];
        controller?.present(activityViewController, animated: true, completion: { () in
            result(nil);
        });
    }
    else {
        result(FlutterMethodNotImplemented);
    }
  }
}
