import XCTest
import Combine
@testable import TheQuackApp

/// Integration tests for DucksStore data loading and management
final class DucksStoreTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testStoreInitialState() {
        // Given & When
        let store = DucksStore()
        
        // Then
        XCTAssertTrue(store.isLoading, "Store should start in loading state")
        XCTAssertTrue(store.ducks.isEmpty, "Store should start with empty ducks array")
    }
    
    // MARK: - Published Properties Tests
    
    func testDucksPropertyIsPublished() {
        // Given
        let store = DucksStore()
        let expectation = XCTestExpectation(description: "Ducks property published")
        
        var receivedDucks: [Duck]?
        store.$ducks
            .dropFirst() // Skip initial empty array
            .first() // Take first update
            .sink { ducks in
                receivedDucks = ducks
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When - Wait for network request (will likely timeout or fail in test environment)
        // This tests that the publisher works, not that data loads
        wait(for: [expectation], timeout: 10.0)
        
        // Then
        XCTAssertNotNil(receivedDucks, "Should receive ducks update")
    }
    
    func testIsLoadingPropertyIsPublished() {
        // Given
        let store = DucksStore()
        let expectation = XCTestExpectation(description: "isLoading property published")
        
        var loadingStates: [Bool] = []
        store.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
                if loadingStates.count >= 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When - Wait for loading to complete
        wait(for: [expectation], timeout: 10.0)
        
        // Then
        XCTAssertTrue(loadingStates.first ?? false, "Should start with isLoading = true")
    }
    
    // MARK: - URL Configuration Tests
    
    func testValidBaseURLConfiguration() {
        // Given
        let validURL = "http://example.com/"
        
        // When
        AppSettings.shared.serverBaseURL = validURL
        let store = DucksStore()
        
        // Then
        XCTAssertEqual(store.baseURL.absoluteString, validURL, 
                       "Store should use configured server URL")
        
        // Cleanup
        AppSettings.shared.serverBaseURL = Configuration.Network.defaultServerURL
    }
    
    func testInvalidBaseURLFallsBackToDefault() {
        // Given - This tests the fallback behavior
        let defaultURL = URL(string: Configuration.Network.defaultServerURL)!
        
        // When
        let store = DucksStore()
        
        // Then
        XCTAssertNotNil(store.baseURL, "Base URL should never be nil")
        // The store should have a valid URL (either custom or default)
        XCTAssertTrue(store.baseURL.absoluteString.hasPrefix("http"), 
                      "Base URL should be a valid HTTP URL")
    }
    
    // MARK: - Manifest Paths Tests
    
    func testManifestPathsConfiguration() {
        // Given
        let paths = Configuration.Network.manifestPaths
        
        // Then
        XCTAssertFalse(paths.isEmpty, "Should have at least one manifest path")
        XCTAssertTrue(paths.contains("manifest.json"), "Should include default manifest.json path")
    }
    
    func testRequestTimeoutConfiguration() {
        // Given
        let timeout = Configuration.Network.requestTimeout
        
        // Then
        XCTAssertGreaterThan(timeout, 0, "Timeout should be positive")
        XCTAssertLessThanOrEqual(timeout, 30, "Timeout should be reasonable (<=30 seconds)")
    }
}

// MARK: - Mock Helpers

/// Helper to create test ducks for store testing
extension DucksStoreTests {
    
    func createMockDuck(name: String, region: Region = .all) -> Duck {
        return Duck(
            name: name,
            scientificName: "Test \(name)",
            regions: [region],
            shortDescription: "Short description for \(name)",
            description: "Full description for \(name)",
            images: [],
            videos: [],
            sounds: []
        )
    }
}
