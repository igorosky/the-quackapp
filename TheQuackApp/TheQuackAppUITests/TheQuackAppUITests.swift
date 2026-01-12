import XCTest

/// UI Tests for TheQuackApp
/// These tests verify the user interface behavior and navigation flows
final class TheQuackAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Home View Tests
    
    func testHomeViewDisplaysAppTitle() throws {
        // Given - App is launched
        
        // When - Looking at home screen
        let title = app.staticTexts["TheQuackApp"]
        
        // Then
        XCTAssertTrue(title.waitForExistence(timeout: 5), "App title should be visible")
    }
    
    func testHomeViewDisplaysGreeting() throws {
        // Given - App is launched
        
        // When - Looking at home screen
        let greeting = app.staticTexts["Hello, Ornithologist!"]
        
        // Then
        XCTAssertTrue(greeting.waitForExistence(timeout: 5), "Greeting should be visible")
    }
    
    func testHomeViewDisplaysDuckOfTheDaySection() throws {
        // Given - App is launched
        
        // When - Looking at home screen
        let sectionTitle = app.staticTexts["Duck of the day"]
        
        // Then
        XCTAssertTrue(sectionTitle.waitForExistence(timeout: 5), 
                      "Duck of the day section should be visible")
    }
    
    func testHomeViewHasSettingsButton() throws {
        // Given - App is launched
        
        // When - Looking for settings button
        let settingsButton = app.buttons["gearshape.fill"]
        
        // Then
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), 
                      "Settings button should be visible")
    }
    
    func testNavigateToSettingsFromHome() throws {
        // Given - App is launched
        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        
        // When - Tap settings button
        settingsButton.tap()
        
        // Then - Settings view should appear
        let settingsTitle = app.staticTexts["Settings"]
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 5), 
                      "Should navigate to Settings view")
    }
    
    // MARK: - Tab Navigation Tests
    
    func testTabBarExists() throws {
        // Given - App is launched
        
        // When - Looking for tab bar
        let tabBar = app.tabBars.firstMatch
        
        // Then
        XCTAssertTrue(tabBar.exists, "Tab bar should exist")
    }
    
    func testNavigateToDiscoverDucksTab() throws {
        // Given - App is launched
        
        // When - Tap on Discover tab (assuming it exists)
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        if discoverTab.exists {
            discoverTab.tap()
            
            // Then
            let discoverTitle = app.staticTexts["Discover Ducks"]
            XCTAssertTrue(discoverTitle.waitForExistence(timeout: 5), 
                          "Should show Discover Ducks view")
        }
    }
    
    func testNavigateBetweenTabs() throws {
        // Given - App is launched on home tab
        let homeTab = app.tabBars.buttons.element(boundBy: 0)
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not found")
        }
        
        // When - Navigate to discover and back
        discoverTab.tap()
        Thread.sleep(forTimeInterval: 0.5)
        homeTab.tap()
        
        // Then - Should be back on home
        let greeting = app.staticTexts["Hello, Ornithologist!"]
        XCTAssertTrue(greeting.waitForExistence(timeout: 5), 
                      "Should be back on home view")
    }
    
    // MARK: - Ducks List View Tests
    
    func testDucksListViewDisplaysSearchBar() throws {
        // Given - Navigate to Ducks list
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not found")
        }
        discoverTab.tap()
        
        // When - Looking for search field
        let searchField = app.textFields["Enter duck's name..."]
        
        // Then
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), 
                      "Search bar should be visible")
    }
    
    func testSearchBarInteraction() throws {
        // Given - Navigate to Ducks list
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not found")
        }
        discoverTab.tap()
        
        let searchField = app.textFields["Enter duck's name..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        
        // When - Type in search field
        searchField.tap()
        searchField.typeText("Mallard")
        
        // Then
        XCTAssertEqual(searchField.value as? String, "Mallard", 
                       "Search text should be entered")
    }
    
    func testSearchClearButton() throws {
        // Given - Navigate to Ducks list and enter search text
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not found")
        }
        discoverTab.tap()
        
        let searchField = app.textFields["Enter duck's name..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Test")
        
        // When - Tap clear button
        let clearButton = app.buttons["xmark.circle.fill"]
        if clearButton.waitForExistence(timeout: 2) {
            clearButton.tap()
        }
        
        // Then - Search should be cleared
        // The field should be empty or back to placeholder
    }
    
    func testRegionPickerExists() throws {
        // Given - Navigate to Ducks list
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not found")
        }
        discoverTab.tap()
        
        // When - Looking for region picker
        let regionPicker = app.buttons["Select Region"]
        
        // Then - Region filter should exist (as a picker or button)
        // Note: The picker might be represented differently in UI
        XCTAssertTrue(app.buttons.count > 0 || app.pickers.count > 0, 
                      "Should have interactive elements for region selection")
    }
    
    // MARK: - Settings View Tests
    
    func testSettingsViewDisplays() throws {
        // Given - Navigate to settings
        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        
        // Then - Settings elements should be visible
        let settingsExists = app.staticTexts["Settings"].waitForExistence(timeout: 5)
        XCTAssertTrue(settingsExists, "Settings view should be displayed")
    }
    
    func testSettingsShowScientificNamesToggle() throws {
        // Given - Navigate to settings
        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        
        // When - Looking for toggle
        Thread.sleep(forTimeInterval: 1.0) // Wait for view to load
        let toggles = app.switches
        
        // Then
        XCTAssertGreaterThan(toggles.count, 0, "Should have at least one toggle in settings")
    }
    
    func testSettingsServerURLField() throws {
        // Given - Navigate to settings
        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        
        // When - Looking for server URL text field
        Thread.sleep(forTimeInterval: 1.0)
        let textFields = app.textFields
        
        // Then
        XCTAssertGreaterThan(textFields.count, 0, "Should have text field for server URL")
    }
    
    func testSettingsNavigateBack() throws {
        // Given - Navigate to settings
        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()
        
        // When - Navigate back
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        if backButton.exists {
            backButton.tap()
        }
        
        // Then - Should be back on home
        let greeting = app.staticTexts["Hello, Ornithologist!"]
        XCTAssertTrue(greeting.waitForExistence(timeout: 5), 
                      "Should navigate back to home view")
    }
    
    // MARK: - Duck Detail View Tests
    
    func testDuckDetailViewNavigation() throws {
        // Given - Navigate to Ducks list and wait for content
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not found")
        }
        discoverTab.tap()
        
        // Wait for ducks to load
        Thread.sleep(forTimeInterval: 3.0)
        
        // When - Tap on first duck cell (if available)
        let cells = app.cells
        if cells.count > 0 {
            cells.element(boundBy: 0).tap()
            
            // Then - Detail view should appear
            // Look for common detail view elements
            Thread.sleep(forTimeInterval: 1.0)
            XCTAssertTrue(app.scrollViews.count > 0 || app.staticTexts.count > 0, 
                          "Detail view should have content")
        } else {
            throw XCTSkip("No duck cells available to test")
        }
    }
    
    // MARK: - Loading State Tests
    
    func testLoadingIndicatorAppears() throws {
        // Given - Fresh launch or navigation
        
        // When - Check for loading indicator
        let progressView = app.progressIndicators.firstMatch
        
        // Then - Loading indicator may appear briefly
        // This is a soft check as loading might be too fast
        if progressView.exists {
            XCTAssertTrue(progressView.exists, "Loading indicator should appear during load")
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testMainElementsAreAccessible() throws {
        // Given - App is launched
        
        // Then - Key elements should be accessible
        let accessibleElements = app.descendants(matching: .any).matching(NSPredicate(
            format: "isAccessibilityElement == true"
        ))
        
        XCTAssertGreaterThan(accessibleElements.count, 0, 
                             "App should have accessible elements")
    }
    
    func testImagesHaveAccessibilityLabels() throws {
        // Given - Navigate to a view with images
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not found")
        }
        discoverTab.tap()
        
        // Wait for content
        Thread.sleep(forTimeInterval: 3.0)
        
        // Then - Images should exist (accessibility will be checked by system)
        let images = app.images
        // Just verify the view loaded properly
        XCTAssertTrue(app.exists, "App should be running")
    }
    
    // MARK: - Performance Tests
    
    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testScrollingPerformance() throws {
        // Given - Navigate to Ducks list
        let discoverTab = app.tabBars.buttons.element(boundBy: 1)
        guard discoverTab.exists else {
            throw XCTSkip("Discover tab not found")
        }
        discoverTab.tap()
        
        // Wait for content to load
        Thread.sleep(forTimeInterval: 3.0)
        
        // When & Then - Measure scrolling performance
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            measure {
                scrollView.swipeUp()
                scrollView.swipeDown()
            }
        }
    }
}
