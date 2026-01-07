import Foundation

enum Configuration {

    enum App {
        static let version = "1.0.0"
        static let name = "TheQuackApp"
    }
    
    enum Network {
        static let defaultServerURL = "http://localhost/"
        static let manifestPaths = [
            "manifest.json",
            "ducks/manifest.json",
            "/ducks/manifest.json"
        ]
        static let requestTimeout: TimeInterval = 6.0
    }
    
    enum UserDefaultsKeys {
        static let showScientificNames = "showScientificNames"
        static let serverBaseURL = "serverBaseURL"
        static let darkMode = "darkMode"
        static let duckOfTheDayName = "duckOfTheDayName"
        static let duckOfTheDayDate = "duckOfTheDayDate"
    }
    
    enum DateFormat {
        static let standardDate = "yyyy-MM-dd"
        static let locale = "en_US_POSIX"
    }
}
