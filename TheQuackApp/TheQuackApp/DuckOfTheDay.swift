import Foundation
import Combine

final class DuckOfTheDay: ObservableObject {
    static let shared = DuckOfTheDay()
    private let nameKey = "duckOfTheDayName"
    private let dateKey = "duckOfTheDayDate"
    
    @Published private(set) var currentDuck: Duck?

    private init() {}

    private func todayString() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: Date())
    }

    // Ensure there's a duck selected for today. If not, pick one randomly and persist it.
    func updateIfNeeded(from ducks: [Duck]) {
        guard !ducks.isEmpty else {
            currentDuck = nil
            return
        }

        let defaults = UserDefaults.standard
        let savedDate = defaults.string(forKey: dateKey)
        let today = todayString()

        if savedDate == today, let savedName = defaults.string(forKey: nameKey) {
            // try to find the duck with this name
            if let found = ducks.first(where: { $0.name == savedName }) {
                currentDuck = found
                return
            }
        }

        // otherwise pick a new one for today
        let chosen = ducks.randomElement()!
        currentDuck = chosen
        defaults.set(chosen.name, forKey: nameKey)
        defaults.set(today, forKey: dateKey)
    }

    // Force a new random duck (useful for debugging or manual refresh)
    func refresh(from ducks: [Duck]) {
        guard !ducks.isEmpty else { currentDuck = nil; return }
        let chosen = ducks.randomElement()!
        currentDuck = chosen
        let defaults = UserDefaults.standard
        defaults.set(chosen.name, forKey: nameKey)
        defaults.set(todayString(), forKey: dateKey)
    }
}
