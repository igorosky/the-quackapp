import Combine
import Foundation

final class DuckOfTheDay: ObservableObject {
    static let shared = DuckOfTheDay()
    private let nameKey = Configuration.UserDefaultsKeys.duckOfTheDayName
    private let dateKey = Configuration.UserDefaultsKeys.duckOfTheDayDate

    @Published private(set) var currentDuck: Duck?

    private init() {}

    private func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Configuration.DateFormat.standardDate
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: Configuration.DateFormat.locale)
        return formatter.string(from: Date())
    }

    // Ensure there's a duck selected for today, if not, pick one randomly and persist it.
    func updateIfNeeded(from ducks: [Duck]) {
        guard !ducks.isEmpty else {
            currentDuck = nil
            return
        }

        let defaults = UserDefaults.standard
        let savedDate = defaults.string(forKey: dateKey)
        let today = todayString()

        if savedDate == today, let savedName = defaults.string(forKey: nameKey)
        {
            // Try to find the duck with this name
            if let found = ducks.first(where: { $0.name == savedName }) {
                currentDuck = found
                return
            }
        }

        // Otherwise pick a new one for today
        let chosen = ducks.randomElement()!
        currentDuck = chosen
        defaults.set(chosen.name, forKey: nameKey)
        defaults.set(today, forKey: dateKey)
    }

    // Force a new random duck
    func refresh(from ducks: [Duck]) {
        guard !ducks.isEmpty else {
            currentDuck = nil
            return
        }
        let chosen = ducks.randomElement()!
        currentDuck = chosen
        let defaults = UserDefaults.standard
        defaults.set(chosen.name, forKey: nameKey)
        defaults.set(todayString(), forKey: dateKey)
    }
}
