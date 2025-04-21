import SwiftUI
import FirebaseCore

@main
struct thankGotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @StateObject var userStore = UserStore()
    @StateObject var letterStore = LetterStore()
    
    init() {
        isLoggedIn = false
    }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
                    .environmentObject(userStore)
                    .environmentObject(letterStore)
                //                    .ignoresSafeArea(.keyboard)
            } else {
                login_signupView()
                    .environmentObject(userStore)
                //                    .ignoresSafeArea(.keyboard)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
