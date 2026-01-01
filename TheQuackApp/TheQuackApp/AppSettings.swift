
import SwiftUI
import Combine

final class AppSettings: ObservableObject {
    // Manual publisher to ensure ObservableObject conformance
    let objectWillChange   = ObservableObjectPublisher()
    private static let key = "showScientificNames"
    static let shared      = AppSettings()

    private static let serverKey = "serverBaseURL"

    var showScientificNames: Bool {
        didSet {
            UserDefaults.standard.set(showScientificNames, forKey: Self.key)
            objectWillChange.send()
        }
    }

    // Base URL for the ducks server (editable in Settings)
    var serverBaseURL: String {
        didSet {
            UserDefaults.standard.set(serverBaseURL, forKey: Self.serverKey)
            objectWillChange.send()
        }
    }

    private init() {
        self.showScientificNames = UserDefaults.standard.object(forKey: Self.key) as? Bool ?? false
        self.serverBaseURL = UserDefaults.standard.string(forKey: Self.serverKey) ?? "http://localhost/"
    }
}

