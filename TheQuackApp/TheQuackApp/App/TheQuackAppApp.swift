import SwiftUI

@main
struct TheQuackAppApp: App {
    @ObservedObject private var settings = AppSettings.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(settings.darkMode ? .dark : .light)
        }
    }
}
