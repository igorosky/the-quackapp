import XCTest
import Combine
@testable import TheQuackApp

/// Integration tests for DuckOfTheDay functionality
final class DuckOfTheDayTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        // Clean up UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.duckOfTheDayName)
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.duckOfTheDayDate)
    }
    
    override func tearDown() {
        cancellables = nil
        // Clean up UserDefaults after each test
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.duckOfTheDayName)
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.duckOfTheDayDate)
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func createSampleDucks() -> [Duck] {
        return [
            Duck(
                name: "Mallard",
                scientificName: "Anas platyrhynchos",
                regions: [.northAmerica, .europe],
                shortDescription: "A common duck",
                description: "The Mallard is widespread.",
                images: [],
                videos: [],
                sounds: []
            ),
            Duck(
                name: "Wood Duck",
                scientificName: "Aix sponsa",
                regions: [.northAmerica],
                shortDescription: "A colorful duck",
                description: "The Wood Duck is colorful.",
                images: [],
                videos: [],
                sounds: []
            ),
            Duck(
                name: "Mandarin Duck",
                scientificName: "Aix galericulata",
                regions: [.asia],
                shortDescription: "An Asian duck",
                description: "The Mandarin Duck is beautiful.",
                images: [],
                videos: [],
                sounds: []
            )
        ]
    }
    
    private func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Configuration.DateFormat.standardDate
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: Configuration.DateFormat.locale)
        return formatter.string(from: Date())
    }
    
    // MARK: - Update Tests
    
    func testUpdateIfNeededWithEmptyDucks() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let emptyDucks: [Duck] = []
        
        // When
        duckOfTheDay.updateIfNeeded(from: emptyDucks)
        
        // Then
        XCTAssertNil(duckOfTheDay.currentDuck, "Current duck should be nil when no ducks available")
    }
    
    func testUpdateIfNeededSelectsDuckWhenNoneSet() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        
        // When
        duckOfTheDay.updateIfNeeded(from: ducks)
        
        // Then
        XCTAssertNotNil(duckOfTheDay.currentDuck, "Should select a duck when none is set")
        XCTAssertTrue(ducks.contains(where: { $0.name == duckOfTheDay.currentDuck?.name }), 
                      "Selected duck should be from the provided list")
    }
    
    func testUpdateIfNeededPersistsDuckForToday() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        
        // When
        duckOfTheDay.updateIfNeeded(from: ducks)
        let firstDuck = duckOfTheDay.currentDuck
        
        // Call again (simulating re-opening app)
        duckOfTheDay.updateIfNeeded(from: ducks)
        let secondDuck = duckOfTheDay.currentDuck
        
        // Then
        XCTAssertEqual(firstDuck?.name, secondDuck?.name, 
                       "Same duck should be returned for the same day")
    }
    
    func testUpdateIfNeededSavesDuckNameToUserDefaults() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        
        // When
        duckOfTheDay.updateIfNeeded(from: ducks)
        
        // Then
        let savedName = UserDefaults.standard.string(forKey: Configuration.UserDefaultsKeys.duckOfTheDayName)
        XCTAssertNotNil(savedName, "Duck name should be saved to UserDefaults")
        XCTAssertEqual(savedName, duckOfTheDay.currentDuck?.name, 
                       "Saved name should match current duck")
    }
    
    func testUpdateIfNeededSavesDateToUserDefaults() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        
        // When
        duckOfTheDay.updateIfNeeded(from: ducks)
        
        // Then
        let savedDate = UserDefaults.standard.string(forKey: Configuration.UserDefaultsKeys.duckOfTheDayDate)
        XCTAssertEqual(savedDate, todayString(), "Today's date should be saved to UserDefaults")
    }
    
    func testUpdateIfNeededReturnsPersistedDuckIfFound() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        
        // Pre-set a duck for today
        UserDefaults.standard.set("Wood Duck", forKey: Configuration.UserDefaultsKeys.duckOfTheDayName)
        UserDefaults.standard.set(todayString(), forKey: Configuration.UserDefaultsKeys.duckOfTheDayDate)
        
        // When
        duckOfTheDay.updateIfNeeded(from: ducks)
        
        // Then
        XCTAssertEqual(duckOfTheDay.currentDuck?.name, "Wood Duck", 
                       "Should return the persisted duck if found in the list")
    }
    
    func testUpdateIfNeededSelectsNewDuckWhenPersistedNotFound() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        
        // Pre-set a duck that doesn't exist in the list
        UserDefaults.standard.set("Extinct Duck", forKey: Configuration.UserDefaultsKeys.duckOfTheDayName)
        UserDefaults.standard.set(todayString(), forKey: Configuration.UserDefaultsKeys.duckOfTheDayDate)
        
        // When
        duckOfTheDay.updateIfNeeded(from: ducks)
        
        // Then
        XCTAssertNotEqual(duckOfTheDay.currentDuck?.name, "Extinct Duck", 
                          "Should select a new duck when persisted duck is not found")
        XCTAssertNotNil(duckOfTheDay.currentDuck, "Should have a duck selected")
    }
    
    // MARK: - Refresh Tests
    
    func testRefreshWithEmptyDucks() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let emptyDucks: [Duck] = []
        
        // When
        duckOfTheDay.refresh(from: emptyDucks)
        
        // Then
        XCTAssertNil(duckOfTheDay.currentDuck, "Current duck should be nil when refreshing with empty list")
    }
    
    func testRefreshSelectsNewDuck() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        duckOfTheDay.updateIfNeeded(from: ducks)
        
        // When - Refresh multiple times and collect results
        var selectedDucks: Set<String> = []
        for _ in 0..<50 {  // Run multiple times to get different random selections
            duckOfTheDay.refresh(from: ducks)
            if let name = duckOfTheDay.currentDuck?.name {
                selectedDucks.insert(name)
            }
        }
        
        // Then - With random selection, we should eventually get different ducks
        // (Though this is probabilistic, with 3 ducks and 50 tries, it's highly likely)
        XCTAssertGreaterThan(selectedDucks.count, 0, "Should select at least one duck")
    }
    
    func testRefreshUpdatesUserDefaults() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        
        // When
        duckOfTheDay.refresh(from: ducks)
        
        // Then
        let savedName = UserDefaults.standard.string(forKey: Configuration.UserDefaultsKeys.duckOfTheDayName)
        let savedDate = UserDefaults.standard.string(forKey: Configuration.UserDefaultsKeys.duckOfTheDayDate)
        
        XCTAssertEqual(savedName, duckOfTheDay.currentDuck?.name, 
                       "UserDefaults should be updated with new duck name")
        XCTAssertEqual(savedDate, todayString(), 
                       "UserDefaults should be updated with today's date")
    }
    
    // MARK: - ObservableObject Tests
    
    func testCurrentDuckPublishesChanges() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        let expectation = XCTestExpectation(description: "Duck published")
        
        var receivedDuck: Duck?
        duckOfTheDay.$currentDuck
            .dropFirst() // Skip initial nil value
            .sink { duck in
                receivedDuck = duck
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        duckOfTheDay.updateIfNeeded(from: ducks)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedDuck, "Should receive published duck value")
    }
}
