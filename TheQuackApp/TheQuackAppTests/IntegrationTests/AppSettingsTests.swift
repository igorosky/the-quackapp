import XCTest
import Combine
@testable import TheQuackApp

/// Integration tests for AppSettings persistence and observable behavior
final class AppSettingsTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    // Store original values to restore after tests
    private var originalShowScientificNames: Bool = false
    private var originalServerBaseURL: String = ""
    private var originalDarkMode: Bool = false
    
    override func setUp() {
        super.setUp()
        cancellables = []
        
        // Save original settings
        originalShowScientificNames = AppSettings.shared.showScientificNames
        originalServerBaseURL = AppSettings.shared.serverBaseURL
        originalDarkMode = AppSettings.shared.darkMode
    }
    
    override func tearDown() {
        // Restore original settings
        AppSettings.shared.showScientificNames = originalShowScientificNames
        AppSettings.shared.serverBaseURL = originalServerBaseURL
        AppSettings.shared.darkMode = originalDarkMode
        
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Singleton Tests
    
    func testSharedInstanceExists() {
        // Given & When
        let settings = AppSettings.shared
        
        // Then
        XCTAssertNotNil(settings, "Shared instance should exist")
    }
    
    func testSharedInstanceIsSingleton() {
        // Given
        let settings1 = AppSettings.shared
        let settings2 = AppSettings.shared
        
        // Then
        XCTAssertTrue(settings1 === settings2, "Should return the same instance")
    }
    
    // MARK: - Show Scientific Names Tests
    
    func testShowScientificNamesDefaultValue() {
        // Given - Clear the setting
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.showScientificNames)
        
        // When - Access setting (will use default)
        let value = UserDefaults.standard.object(forKey: Configuration.UserDefaultsKeys.showScientificNames) as? Bool
        
        // Then
        XCTAssertNil(value, "Default should be nil (false when accessed)")
    }
    
    func testShowScientificNamesPersistence() {
        // Given
        let settings = AppSettings.shared
        
        // When
        settings.showScientificNames = true
        
        // Then
        let persisted = UserDefaults.standard.bool(forKey: Configuration.UserDefaultsKeys.showScientificNames)
        XCTAssertTrue(persisted, "Value should be persisted to UserDefaults")
    }
    
    func testShowScientificNamesToggle() {
        // Given
        let settings = AppSettings.shared
        let initial = settings.showScientificNames
        
        // When
        settings.showScientificNames = !initial
        
        // Then
        XCTAssertNotEqual(settings.showScientificNames, initial, "Value should be toggled")
    }
    
    // MARK: - Server Base URL Tests
    
    func testServerBaseURLDefaultValue() {
        // Given
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.serverBaseURL)
        
        // When - The default is set in init, so we check Configuration
        let defaultURL = Configuration.Network.defaultServerURL
        
        // Then
        XCTAssertEqual(defaultURL, "http://localhost/", "Default URL should be localhost")
    }
    
    func testServerBaseURLPersistence() {
        // Given
        let settings = AppSettings.shared
        let newURL = "http://test.example.com/"
        
        // When
        settings.serverBaseURL = newURL
        
        // Then
        let persisted = UserDefaults.standard.string(forKey: Configuration.UserDefaultsKeys.serverBaseURL)
        XCTAssertEqual(persisted, newURL, "URL should be persisted to UserDefaults")
    }
    
    func testServerBaseURLWithDifferentFormats() {
        // Given
        let settings = AppSettings.shared
        let urls = [
            "http://localhost/",
            "http://192.168.1.100:8080/",
            "https://api.example.com/ducks/",
            "http://localhost:3000"
        ]
        
        // When & Then
        for url in urls {
            settings.serverBaseURL = url
            XCTAssertEqual(settings.serverBaseURL, url, "Should accept URL: \(url)")
        }
    }
    
    // MARK: - Dark Mode Tests
    
    func testDarkModeDefaultValue() {
        // Given - Clear the setting
        UserDefaults.standard.removeObject(forKey: Configuration.UserDefaultsKeys.darkMode)
        
        // When - Access setting (will use default)
        let value = UserDefaults.standard.object(forKey: Configuration.UserDefaultsKeys.darkMode) as? Bool
        
        // Then
        XCTAssertNil(value, "Default should be nil (false when accessed)")
    }
    
    func testDarkModePersistence() {
        // Given
        let settings = AppSettings.shared
        
        // When
        settings.darkMode = true
        
        // Then
        let persisted = UserDefaults.standard.bool(forKey: Configuration.UserDefaultsKeys.darkMode)
        XCTAssertTrue(persisted, "Dark mode should be persisted to UserDefaults")
    }
    
    func testDarkModeToggle() {
        // Given
        let settings = AppSettings.shared
        let initial = settings.darkMode
        
        // When
        settings.darkMode = !initial
        
        // Then
        XCTAssertNotEqual(settings.darkMode, initial, "Dark mode should be toggled")
    }
    
    // MARK: - Observable Tests
    
    func testSettingsPublishesChangesForScientificNames() {
        // Given
        let settings = AppSettings.shared
        let expectation = XCTestExpectation(description: "Settings published change")
        
        var changeReceived = false
        settings.objectWillChange
            .sink {
                changeReceived = true
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        settings.showScientificNames = !settings.showScientificNames
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(changeReceived, "Should publish change notification")
    }
    
    func testSettingsPublishesChangesForServerURL() {
        // Given
        let settings = AppSettings.shared
        let expectation = XCTestExpectation(description: "Settings published change")
        
        var changeReceived = false
        settings.objectWillChange
            .sink {
                changeReceived = true
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        settings.serverBaseURL = "http://changed.example.com/"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(changeReceived, "Should publish change notification for URL")
    }
    
    func testSettingsPublishesChangesForDarkMode() {
        // Given
        let settings = AppSettings.shared
        let expectation = XCTestExpectation(description: "Settings published change")
        
        var changeReceived = false
        settings.objectWillChange
            .sink {
                changeReceived = true
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        settings.darkMode = !settings.darkMode
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(changeReceived, "Should publish change notification for dark mode")
    }
    
    // MARK: - Edge Cases
    
    func testEmptyServerURL() {
        // Given
        let settings = AppSettings.shared
        
        // When
        settings.serverBaseURL = ""
        
        // Then
        XCTAssertEqual(settings.serverBaseURL, "", "Should accept empty string")
    }
    
    func testMultipleRapidChanges() {
        // Given
        let settings = AppSettings.shared
        let expectation = XCTestExpectation(description: "Multiple changes")
        expectation.expectedFulfillmentCount = 3
        
        settings.objectWillChange
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        settings.showScientificNames = true
        settings.darkMode = true
        settings.serverBaseURL = "http://rapid.test/"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
