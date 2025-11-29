import SwiftUI
import Combine

final class AppSettings: ObservableObject {
    // Manual publisher to ensure ObservableObject conformance
    let objectWillChange = ObservableObjectPublisher()

    private static let key = "showScientificNames"

    static let shared = AppSettings()

    var showScientificNames: Bool {
        didSet {
            UserDefaults.standard.set(showScientificNames, forKey: Self.key)
            objectWillChange.send()
        }
    }

    private init() {
        self.showScientificNames = UserDefaults.standard.object(forKey: Self.key) as? Bool ?? false
    }
}

