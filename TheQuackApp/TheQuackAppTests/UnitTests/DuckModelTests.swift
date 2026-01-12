import XCTest
@testable import TheQuackApp

/// Unit tests for the Duck model and related types
final class DuckModelTests: XCTestCase {
    
    // MARK: - Duck Model Tests
    
    func testDuckInitialization() {
        // Given
        let name = "Mallard"
        let scientificName = "Anas platyrhynchos"
        let regions: [Region] = [.northAmerica, .europe]
        let shortDescription = "A common duck species"
        let description = "The Mallard is one of the most recognized duck species worldwide."
        let images = ["image1.jpg", "image2.jpg"]
        let videos = ["video1.mp4"]
        let sounds = ["quack.mp3"]
        
        // When
        let duck = Duck(
            name: name,
            scientificName: scientificName,
            regions: regions,
            shortDescription: shortDescription,
            description: description,
            coolFacts: "Can fly up to 55 mph",
            findThisBird: "Found near ponds and lakes",
            images: images,
            videos: videos,
            sounds: sounds
        )
        
        // Then
        XCTAssertEqual(duck.name, name)
        XCTAssertEqual(duck.scientificName, scientificName)
        XCTAssertEqual(duck.regions, regions)
        XCTAssertEqual(duck.shortDescription, shortDescription)
        XCTAssertEqual(duck.description, description)
        XCTAssertEqual(duck.coolFacts, "Can fly up to 55 mph")
        XCTAssertEqual(duck.findThisBird, "Found near ponds and lakes")
        XCTAssertEqual(duck.images.count, 2)
        XCTAssertEqual(duck.videos.count, 1)
        XCTAssertEqual(duck.sounds.count, 1)
    }
    
    func testDuckWithNilOptionalProperties() {
        // Given & When
        let duck = Duck(
            name: "Wood Duck",
            scientificName: nil,
            regions: [.all],
            shortDescription: "A colorful duck",
            description: "The Wood Duck is known for its colorful plumage.",
            coolFacts: nil,
            findThisBird: nil,
            images: [],
            videos: [],
            sounds: []
        )
        
        // Then
        XCTAssertEqual(duck.name, "Wood Duck")
        XCTAssertNil(duck.scientificName)
        XCTAssertNil(duck.coolFacts)
        XCTAssertNil(duck.findThisBird)
        XCTAssertTrue(duck.images.isEmpty)
        XCTAssertTrue(duck.videos.isEmpty)
        XCTAssertTrue(duck.sounds.isEmpty)
    }
    
    func testDuckIdentifiable() {
        // Given
        let duck1 = Duck(
            name: "Mallard",
            scientificName: nil,
            regions: [.all],
            shortDescription: "Test",
            description: "Test description",
            images: [],
            videos: [],
            sounds: []
        )
        
        let duck2 = Duck(
            name: "Mallard",
            scientificName: nil,
            regions: [.all],
            shortDescription: "Test",
            description: "Test description",
            images: [],
            videos: [],
            sounds: []
        )
        
        // Then - Each duck should have a unique ID
        XCTAssertNotEqual(duck1.id, duck2.id)
    }
    
    func testDuckHashable() {
        // Given
        let duck = Duck(
            name: "Teal",
            scientificName: "Anas crecca",
            regions: [.europe],
            shortDescription: "Small duck",
            description: "A small dabbling duck.",
            images: [],
            videos: [],
            sounds: []
        )
        
        // When
        var set: Set<Duck> = []
        set.insert(duck)
        set.insert(duck) // Inserting same duck again
        
        // Then
        XCTAssertEqual(set.count, 1, "Set should contain only one instance of the same duck")
    }
    
    func testDuckEquatable() {
        // Given
        let duck1 = Duck(
            name: "Mallard",
            scientificName: nil,
            regions: [.all],
            shortDescription: "Test",
            description: "Test description",
            images: [],
            videos: [],
            sounds: []
        )
        
        // When - Same instance comparison
        let duck2 = duck1
        
        // Then
        XCTAssertEqual(duck1, duck2, "Same duck instances should be equal")
    }
    
    // MARK: - Region Tests
    
    func testRegionRawValues() {
        XCTAssertEqual(Region.all.rawValue, "All")
        XCTAssertEqual(Region.northAmerica.rawValue, "North America")
        XCTAssertEqual(Region.southAmerica.rawValue, "South America")
        XCTAssertEqual(Region.europe.rawValue, "Europe")
        XCTAssertEqual(Region.asia.rawValue, "Asia")
        XCTAssertEqual(Region.africa.rawValue, "Africa")
        XCTAssertEqual(Region.oceania.rawValue, "Oceania")
        XCTAssertEqual(Region.antarctica.rawValue, "Antarctica")
    }
    
    func testRegionCaseIterableCount() {
        // Given
        let expectedCount = 8
        
        // When
        let actualCount = Region.allCases.count
        
        // Then
        XCTAssertEqual(actualCount, expectedCount, "Should have 8 regions")
    }
    
    func testRegionInitFromRawValue() {
        // Given
        let validRawValue = "Europe"
        let invalidRawValue = "Mars"
        
        // When
        let validRegion = Region(rawValue: validRawValue)
        let invalidRegion = Region(rawValue: invalidRawValue)
        
        // Then
        XCTAssertEqual(validRegion, .europe)
        XCTAssertNil(invalidRegion)
    }
    
    func testAllRegionsHaveNonEmptyRawValues() {
        for region in Region.allCases {
            XCTAssertFalse(region.rawValue.isEmpty, "Region \(region) should have non-empty raw value")
        }
    }
    
    // MARK: - Configuration Tests
    
    func testConfigurationAppConstants() {
        XCTAssertEqual(Configuration.App.version, "1.0.0")
        XCTAssertEqual(Configuration.App.name, "TheQuackApp")
    }
    
    func testConfigurationNetworkConstants() {
        XCTAssertEqual(Configuration.Network.defaultServerURL, "http://localhost/")
        XCTAssertEqual(Configuration.Network.requestTimeout, 6.0)
        XCTAssertFalse(Configuration.Network.manifestPaths.isEmpty)
        XCTAssertTrue(Configuration.Network.manifestPaths.contains("manifest.json"))
    }
    
    func testConfigurationUserDefaultsKeys() {
        XCTAssertEqual(Configuration.UserDefaultsKeys.showScientificNames, "showScientificNames")
        XCTAssertEqual(Configuration.UserDefaultsKeys.serverBaseURL, "serverBaseURL")
        XCTAssertEqual(Configuration.UserDefaultsKeys.darkMode, "darkMode")
        XCTAssertEqual(Configuration.UserDefaultsKeys.duckOfTheDayName, "duckOfTheDayName")
        XCTAssertEqual(Configuration.UserDefaultsKeys.duckOfTheDayDate, "duckOfTheDayDate")
    }
    
    func testConfigurationDateFormatConstants() {
        XCTAssertEqual(Configuration.DateFormat.standardDate, "yyyy-MM-dd")
        XCTAssertEqual(Configuration.DateFormat.locale, "en_US_POSIX")
    }
}
