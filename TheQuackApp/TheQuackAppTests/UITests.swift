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
    
    // MARK: - Test 2: Tab Navigation Works
    /// Verifies that users can navigate between tabs
    func testTabNavigationBetweenHomeAndDiscover() throws {
        // Given
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist")
        
        let homeTab = app.tabBars.buttons.element(boundBy: 0)
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not available")
        }
        
        // When - Navigate to Discover tab
        discoverTab.tap()
        
        // Then - Discover view should appear
        let discoverTitle = app.staticTexts["Discover Ducks"]
        XCTAssertTrue(discoverTitle.waitForExistence(timeout: 5), "Discover Ducks view should appear")
        
        // When - Navigate back to Home
        homeTab.tap()
        
        // Then - Home view should appear
        let greeting = app.staticTexts["Hello, Ornithologist!"]
        XCTAssertTrue(greeting.waitForExistence(timeout: 5), "Should return to home view")
    }
    
    // MARK: - Test 3: Settings Navigation and Content
    /// Verifies that settings view opens and contains expected controls
    func testSettingsViewOpensAndContainsControls() throws {
        // Given
        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        
        // When
        settingsButton.tap()
        
        // Then - Settings should be displayed with controls
        Thread.sleep(forTimeInterval: 1.0) // Wait for view load
        
        let toggles = app.switches
        let textFields = app.textFields
        
        XCTAssertGreaterThan(toggles.count, 0, "Settings should have toggle controls")
        XCTAssertGreaterThan(textFields.count, 0, "Settings should have text field for server URL")
    }
    
    // MARK: - Test 4: Search Functionality in Ducks List
    /// Verifies that search bar works in the Ducks list view
    func testSearchBarAcceptsInputInDucksList() throws {
        // Given - Navigate to Discover tab
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not available")
        }
        discoverTab.tap()
        
        // When - Find and interact with search bar
        let searchField = app.textFields["Enter duck's name..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search bar should be visible")
        
        searchField.tap()
        searchField.typeText("Mallard")
        
        // Then - Search text should be entered
        XCTAssertEqual(searchField.value as? String, "Mallard", "Search text should be accepted")
        
        // Verify clear button appears
        let clearButton = app.buttons["xmark.circle.fill"]
        XCTAssertTrue(clearButton.waitForExistence(timeout: 2), "Clear button should appear when text is entered")
    }
}
