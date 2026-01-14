import XCTest
@testable import TheQuackApp

/// Unit tests for TheQuackApp models and data types
final class UnitTests: XCTestCase {
    
    // MARK: - Test 1: Duck Model Initialization
    /// Verifies that a Duck model can be properly initialized with all properties
    func testDuckModelInitializationWithAllProperties() {
        // Given
        let name = "Mallard"
        let scientificName = "Anas platyrhynchos"
        let regions: [Region] = [.northAmerica, .europe]
        let images = ["image1.jpg", "image2.jpg"]
        
        // When
        let duck = Duck(
            name: name,
            scientificName: scientificName,
            regions: regions,
            shortDescription: "A common duck",
            description: "The Mallard is widespread.",
            coolFacts: "Can fly up to 55 mph",
            findThisBird: "Found near ponds",
            images: images,
            videos: ["video.mp4"],
            sounds: ["quack.mp3"]
        )
        
        // Then
        XCTAssertEqual(duck.name, name)
        XCTAssertEqual(duck.scientificName, scientificName)
        XCTAssertEqual(duck.regions, regions)
        XCTAssertEqual(duck.images.count, 2)
        XCTAssertNotNil(duck.id, "Duck should have a unique identifier")
    }
    
    // MARK: - Test 2: Duck Uniqueness (Identifiable)
    /// Verifies that each Duck instance gets a unique ID even with same data
    func testEachDuckHasUniqueIdentifier() {
        // Given - Two ducks with identical data
        let duck1 = Duck(
            name: "Mallard",
            scientificName: nil,
            regions: [.all],
            shortDescription: "Test",
            description: "Test description",
            images: [], videos: [], sounds: []
        )
        
        let duck2 = Duck(
            name: "Mallard",
            scientificName: nil,
            regions: [.all],
            shortDescription: "Test",
            description: "Test description",
            images: [], videos: [], sounds: []
        )
        
        // Then - Each should have unique ID
        XCTAssertNotEqual(duck1.id, duck2.id, "Different duck instances should have unique IDs")
    }
    
    // MARK: - Test 3: Region Enum Completeness
    /// Verifies all expected regions exist and have correct raw values
    func testRegionEnumHasAllContinentsWithCorrectValues() {
        // Then - All 8 regions should exist with correct raw values
        XCTAssertEqual(Region.allCases.count, 8, "Should have 8 regions")
        XCTAssertEqual(Region.all.rawValue, "All")
        XCTAssertEqual(Region.northAmerica.rawValue, "North America")
        XCTAssertEqual(Region.europe.rawValue, "Europe")
        XCTAssertEqual(Region.asia.rawValue, "Asia")
        XCTAssertEqual(Region.southAmerica.rawValue, "South America")
        XCTAssertEqual(Region.africa.rawValue, "Africa")
        XCTAssertEqual(Region.oceania.rawValue, "Oceania")
        XCTAssertEqual(Region.antarctica.rawValue, "Antarctica")
        
        // Verify region can be created from raw value
        XCTAssertEqual(Region(rawValue: "Europe"), .europe)
        XCTAssertNil(Region(rawValue: "Invalid"), "Invalid region should return nil")
    }
    
    // MARK: - Test 4: DuckManifestItem JSON Decoding
    /// Verifies that manifest JSON from server can be properly decoded
    @MainActor func testDuckManifestItemDecodesFromJSON() throws {
        // Given - JSON structure matching server response
        let json = """
        {
            "species_name": "Mallard",
            "scientific_name": "Anas platyrhynchos",
            "basic_description": "ducks/mallard/description.txt",
            "images": ["mallard1.jpg", "mallard2.jpg"],
            "videos": ["mallard.mp4"],
            "sounds": ["quack.mp3"],
            "regions": ["North America", "Europe"]
        }
        """.data(using: .utf8)!
        
        // When
        let item = try JSONDecoder().decode(DuckManifestItem.self, from: json)
        
        // Then
        XCTAssertEqual(item.species_name, "Mallard")
        XCTAssertEqual(item.scientific_name, "Anas platyrhynchos")
        XCTAssertEqual(item.images?.count, 2)
        XCTAssertEqual(item.regions?.count, 2)
        XCTAssertTrue(item.regions?.contains("North America") ?? false)
    }
}
