import XCTest

/// UI Tests for TheQuackApp user interface and navigation
final class UITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Test 1: Home Screen Displays Correctly
    /// Verifies that the home screen shows all expected elements after launch
    func testHomeScreenDisplaysAllExpectedElements() throws {
        // Then - Verify main home screen elements
        let appTitle = app.staticTexts["TheQuackApp"]
        let greeting = app.staticTexts["Hello, Ornithologist!"]
        let duckOfDaySection = app.staticTexts["Duck of the day"]
        let settingsButton = app.buttons["gearshape.fill"]
        
        XCTAssertTrue(appTitle.waitForExistence(timeout: 5), "App title should be visible")
        XCTAssertTrue(greeting.waitForExistence(timeout: 5), "Greeting should be visible")
        XCTAssertTrue(duckOfDaySection.waitForExistence(timeout: 5), "Duck of the day section should be visible")
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button should be visible")
    }
    
    // MARK: - Test 2: App Launches Successfully
    /// Verifies that the app launches and displays the main title
    func testAppLaunchesSuccessfully() throws {
        // Then - App title should be visible after launch
        let appTitle = app.staticTexts["TheQuackApp"]
        XCTAssertTrue(appTitle.exists, "App should launch and display title")
    }
    
    // MARK: - Test 3: Duck of the Day Section Exists
    /// Verifies that the Duck of the Day section is displayed on home screen
    func testDuckOfTheDaySectionDisplayed() throws {
        // Given - Home screen is visible
        let duckOfDaySection = app.staticTexts["Duck of the day"]
        
        // Then - Section should be visible
        XCTAssertTrue(duckOfDaySection.waitForExistence(timeout: 5), "Duck of the day section should be displayed")
        
        // Verify the greeting is still visible (we're still on home screen)
        let greeting = app.staticTexts["Hello, Ornithologist!"]
        XCTAssertTrue(greeting.exists, "Should still be on home screen")
    }
    
    // MARK: - Test 4: Settings Button Exists
    /// Verifies that the settings button is accessible
    func testSettingsButtonExists() throws {
        // Then - Settings button should be present
        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button should be accessible")
    }
}
