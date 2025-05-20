import Flutter
import UIKit
import GoogleMaps
import FirebaseCore
import FirebaseRemoteConfig

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    // Initialize Remote Config
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings
    
    // Set default values
    remoteConfig.setDefaults([
      "spotify_client_id": "826c83b9cc66470b98e91492884bab68",
      "spotify_client_secret": "95bed038b55d4a519d328c4dfe032ce0",
      "youtube_api_key": "AIzaSyABz9tCdUz29okHDMNQYEMX-LuvNUtjZZw",
      "unsplash_api_key": "eyfC5QB1_xUKVD3T4v1fBbFtxFrs514GA1WXTUsFHvg",
      "tmdb_api_key": "d333a0b62b637851256f90a16c56f448",
      "gemini_api_key": "AIzaSyDEJ-TeTsk73dHZ9-IJFdPv2QSpmwEjCiI",
      "google_api_key": "AIzaSyDZcRuk8N_f5lXL9EFvEyDzMP3QJYpuov4",
      "search_engine_id": "017576662512468239146:omuauf_lfve",
      "google_maps_api_key": "AIzaSyABz9tCdUz29okHDMNQYEMX-LuvNUtjZZw"
    ] as [String: Any])
    
    // Fetch and activate Remote Config
    remoteConfig.fetchAndActivate { status, error in
      if status == .successFetchedFromRemote {
        // Initialize Google Maps with the key from Remote Config
        let mapsApiKey = remoteConfig.configValue(forKey: "google_maps_api_key").stringValue ?? ""
        GMSServices.provideAPIKey(mapsApiKey)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.trackeat.app/accessibility",
                                              binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let _ = self else { return }
      
      switch call.method {
      case "toggleVoiceOver":
        // Try multiple URL schemes to ensure compatibility
        let urls = [
          "App-Prefs:root=General&path=ACCESSIBILITY/VOICEOVER",
          "app-settings:root=General&path=ACCESSIBILITY/VOICEOVER",
          "prefs:root=General&path=ACCESSIBILITY/VOICEOVER"
        ]
        
        var opened = false
        for urlString in urls {
          if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
              if success {
                opened = true
                result(true)
              }
            }
            break
          }
        }
        
        if !opened {
          // Fallback to general settings
          if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl, options: [:]) { success in
              result(success)
            }
          } else {
            result(false)
          }
        }
      case "isVoiceAssistantEnabled":
        result(UIAccessibility.isVoiceOverRunning)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
