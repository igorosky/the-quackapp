import XCTest

/// Launch tests for TheQuackApp
/// These tests verify the app launches correctly and measure launch performance
final class TheQuackAppUITestsLaunchTests: XCTestCase {
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify the app launched successfully
        XCTAssertTrue(app.exists, "App should launch successfully")
        
        // Take a screenshot of the launch state
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testLaunchToHomeView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify home view appears after launch
        let greeting = app.staticTexts["Hello, Ornithologist!"]
        XCTAssertTrue(greeting.waitForExistence(timeout: 10), 
                      "Home view should appear after launch")
        
        // Take a screenshot
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Home View After Launch"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testLaunchWithDifferentOrientations() throws {
        let app = XCUIApplication()
        
        // Test portrait launch
        XCUIDevice.shared.orientation = .portrait
        app.launch()
        XCTAssertTrue(app.exists, "App should launch in portrait")
        
        let portraitAttachment = XCTAttachment(screenshot: app.screenshot())
        portraitAttachment.name = "Launch - Portrait"
        portraitAttachment.lifetime = .keepAlways
        add(portraitAttachment)
        
        // Test landscape
        XCUIDevice.shared.orientation = .landscapeLeft
        Thread.sleep(forTimeInterval: 1.0)
        
        let landscapeAttachment = XCTAttachment(screenshot: app.screenshot())
        landscapeAttachment.name = "Launch - Landscape"
        landscapeAttachment.lifetime = .keepAlways
        add(landscapeAttachment)
    }
    
    func testLaunchInDarkMode() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleInterfaceStyle", "Dark"]
        app.launch()
        
        XCTAssertTrue(app.exists, "App should launch in dark mode")
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch - Dark Mode"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testLaunchInLightMode() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleInterfaceStyle", "Light"]
        app.launch()
        
        XCTAssertTrue(app.exists, "App should launch in light mode")
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch - Light Mode"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
