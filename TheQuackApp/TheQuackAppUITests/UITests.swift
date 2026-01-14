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
    func testHomeScreenDisplaysAllExpectedElements() {
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
    
    // MARK: - Test 2: Navigation to Settings
    /// Verifies that tapping the settings button navigates to the settings screen
    func testNavigationToSettings() {
        // Given - Settings button is visible
        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        
        // When - User taps settings button
        settingsButton.tap()
        
        // Then - Settings screen should be displayed
        let settingsTitle = app.staticTexts["Settings"]
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 5), "Settings screen should be displayed")
    }

    // MARK: - Test 3: Back Navigation from Settings
    /// Verifies that users can navigate back from settings to home screen
    func testBackNavigationFromSettings() {
        // Given - User navigates to settings
        let settingsButton = app.buttons["gearshape.fill"]
        settingsButton.tap()
        
        let settingsTitle = app.staticTexts["Settings"]
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 5))
        
        // When - User taps back button
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()
        
        // Then - Should return to home screen
        let greeting = app.staticTexts["Hello, Ornithologist!"]
        XCTAssertTrue(greeting.waitForExistence(timeout: 5), "Should navigate back to home screen")
    }
    
    // MARK: - Test 4: Duck List Navigation
    /// Verifies navigation to the duck list view
    func testTabNavigation() {
        // Given - Search button is visible
        let searchButton = app.buttons["Search for ducks"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 5), "Search button should be displayed")
        
        // When - Navigate to ducks list
        searchButton.tap()
        
        // Then - Ducks list should be displayed
        let ducksTitle = app.staticTexts["Discover Ducks"]
        XCTAssertTrue(ducksTitle.waitForExistence(timeout: 5), "Ducks list screen should be displayed")
        
        // Given - Navigate back to verify navigation works
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()
        
        // Then - Should be back on home screen
        let greeting = app.staticTexts["Hello, Ornithologist!"]
        XCTAssertTrue(greeting.waitForExistence(timeout: 5), "Should return to home screen")
    }

}
