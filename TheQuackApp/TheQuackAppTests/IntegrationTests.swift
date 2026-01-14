import XCTest
import Combine
@testable import TheQuackApp

/// Integration tests for TheQuackApp component interactions
final class IntegrationTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        // Clean up UserDefaults
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.duckOfTheDayName)
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.duckOfTheDayDate)
    }
    
    override func tearDown() {
        // Clean up UserDefaults
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.duckOfTheDayName)
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.duckOfTheDayDate)
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Helper
    
    private func createSampleDucks() -> [Duck] {
        return [
            Duck(name: "Mallard", scientificName: "Anas platyrhynchos",
                 regions: [.northAmerica], shortDescription: "Common duck",
                 description: "Widespread duck.", images: [], videos: [], sounds: []),
            Duck(name: "Wood Duck", scientificName: "Aix sponsa",
                 regions: [.northAmerica], shortDescription: "Colorful duck",
                 description: "Beautiful duck.", images: [], videos: [], sounds: []),
            Duck(name: "Mandarin Duck", scientificName: "Aix galericulata",
                 regions: [.asia], shortDescription: "Asian duck",
                 description: "Ornate duck.", images: [], videos: [], sounds: [])
        ]
    }
    
    // MARK: - Test 1: Duck of the Day Selection and Persistence
    /// Verifies that DuckOfTheDay selects a duck and persists it for the day
    func testDuckOfTheDaySelectsAndPersistsDuck() {
        // Given
        let duckOfTheDay = DuckOfTheDay.shared
        let ducks = createSampleDucks()
        
        // When - First selection
        duckOfTheDay.updateIfNeeded(from: ducks)
        let firstSelection = duckOfTheDay.currentDuck?.name
        
        // Simulate app relaunch by calling update again
        duckOfTheDay.updateIfNeeded(from: ducks)
        let secondSelection = duckOfTheDay.currentDuck?.name
        
        // Then
        XCTAssertNotNil(firstSelection, "Should select a duck")
        XCTAssertEqual(firstSelection, secondSelection, "Same duck should persist for the day")
        
        // Verify persistence in UserDefaults
        let savedName = UserDefaults.standard.string(forKey: Configuration.UserDefaultsKeys.duckOfTheDayName)
        XCTAssertEqual(savedName, firstSelection, "Duck name should be saved to UserDefaults")
    }
    
    // MARK: - Test 2: DucksStore Initial State and Loading
    /// Verifies that DucksStore initializes correctly and enters loading state
    func testDucksStoreInitializesWithLoadingState() {
        // When
        let store = DucksStore()
        
        // Then
        XCTAssertTrue(store.isLoading, "Store should start in loading state")
        XCTAssertTrue(store.ducks.isEmpty, "Store should start with empty ducks")
        XCTAssertNotNil(store.baseURL, "Store should have a valid base URL")
        XCTAssertTrue(store.baseURL.absoluteString.hasPrefix("http"), "Base URL should be HTTP")
    }
    
    // MARK: - Test 3: AppSettings Persistence to UserDefaults
    /// Verifies that AppSettings properly saves and loads values from UserDefaults
    func testAppSettingsPersistsToUserDefaults() {
        // Given
        let settings = AppSettings.shared
        let originalValue = settings.showScientificNames
        let testURL = "https://test.example.com/"
        let originalURL = settings.serverBaseURL
        
        // When - Modify settings
        settings.showScientificNames = !originalValue
        settings.serverBaseURL = testURL
        
        // Then - Values should be persisted
        let persistedNames = UserDefaults.standard.bool(forKey: Configuration.UserDefaultsKeys.showScientificNames)
        let persistedURL = UserDefaults.standard.string(forKey: Configuration.UserDefaultsKeys.serverBaseURL)
        
        XCTAssertEqual(persistedNames, !originalValue, "Scientific names toggle should persist")
        XCTAssertEqual(persistedURL, testURL, "Server URL should persist")
        
        // Cleanup
        settings.showScientificNames = originalValue
        settings.serverBaseURL = originalURL
    }
    
    // MARK: - Test 4: AppSettings Observable Publishes Changes
    /// Verifies that AppSettings publishes changes for SwiftUI reactivity
    func testAppSettingsPublishesChangesToObservers() {
        // Given
        let settings = AppSettings.shared
        let expectation = XCTestExpectation(description: "Settings change published")
        let originalValue = settings.darkMode
        
        var changeReceived = false
        settings.objectWillChange
            .sink {
                changeReceived = true
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        settings.darkMode = !originalValue
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(changeReceived, "ObservableObject should publish changes")
        
        // Cleanup
        settings.darkMode = originalValue
    }
}
