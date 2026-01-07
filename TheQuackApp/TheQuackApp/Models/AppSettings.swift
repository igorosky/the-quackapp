import Combine
import SwiftUI

final class AppSettings: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    private static let namesKey = Configuration.UserDefaultsKeys.showScientificNames
    private static let serverKey = Configuration.UserDefaultsKeys.serverBaseURL
    private static let darkModeKey = Configuration.UserDefaultsKeys.darkMode
    static let shared = AppSettings()

    // Tells whether to show scientific names in the UI
    var showScientificNames: Bool {
        didSet {
            UserDefaults.standard.set(
                showScientificNames,
                forKey: Self.namesKey
            )
            objectWillChange.send()
        }
    }

    // Base URL for the ducks server (editable in SettingsView)
    var serverBaseURL: String {
        didSet {
            UserDefaults.standard.set(serverBaseURL, forKey: Self.serverKey)
            objectWillChange.send()
        }
    }

    // Dark mode preferences
    var darkMode: Bool {
        didSet {
            UserDefaults.standard.set(darkMode, forKey: Self.darkModeKey)
            objectWillChange.send()
        }
    }

    private init() {
        self.showScientificNames =
            UserDefaults.standard.object(forKey: Self.namesKey) as? Bool
            ?? false
        self.serverBaseURL =
            UserDefaults.standard.string(forKey: Self.serverKey)
            ?? Configuration.Network.defaultServerURL
        self.darkMode =
            UserDefaults.standard.object(forKey: Self.darkModeKey) as? Bool
            ?? false
    }
}
