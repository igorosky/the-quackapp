import XCTest
@testable import TheQuackApp

/// Unit tests for DuckManifestItem JSON decoding
final class DuckManifestItemTests: XCTestCase {
    
    // MARK: - JSON Decoding Tests
    
    func testFullManifestItemDecoding() throws {
        // Given
        let json = """
        {
            "species_name": "Mallard",
            "scientific_name": "Anas platyrhynchos",
            "basic_description": "ducks/mallard/description.txt",
            "cool_facts": "ducks/mallard/cool_facts.txt",
            "find_this_bird": "ducks/mallard/find.txt",
            "images": ["ducks/mallard/img1.jpg", "ducks/mallard/img2.jpg"],
            "videos": ["ducks/mallard/video.mp4"],
            "sounds": ["ducks/mallard/quack.mp3"],
            "regions": ["North America", "Europe"]
        }
        """.data(using: .utf8)!
        
        // When
        let item = try JSONDecoder().decode(DuckManifestItem.self, from: json)
        
        // Then
        XCTAssertEqual(item.species_name, "Mallard")
        XCTAssertEqual(item.scientific_name, "Anas platyrhynchos")
        XCTAssertEqual(item.basic_description, "ducks/mallard/description.txt")
        XCTAssertEqual(item.cool_facts, "ducks/mallard/cool_facts.txt")
        XCTAssertEqual(item.find_this_bird, "ducks/mallard/find.txt")
        XCTAssertEqual(item.images?.count, 2)
        XCTAssertEqual(item.videos?.count, 1)
        XCTAssertEqual(item.sounds?.count, 1)
        XCTAssertEqual(item.regions?.count, 2)
    }
    
    func testMinimalManifestItemDecoding() throws {
        // Given - JSON with only species_name
        let json = """
        {
            "species_name": "Unknown Duck"
        }
        """.data(using: .utf8)!
        
        // When
        let item = try JSONDecoder().decode(DuckManifestItem.self, from: json)
        
        // Then
        XCTAssertEqual(item.species_name, "Unknown Duck")
        XCTAssertNil(item.scientific_name)
        XCTAssertNil(item.basic_description)
        XCTAssertNil(item.cool_facts)
        XCTAssertNil(item.find_this_bird)
        XCTAssertNil(item.images)
        XCTAssertNil(item.videos)
        XCTAssertNil(item.sounds)
        XCTAssertNil(item.regions)
    }
    
    func testEmptyManifestItemDecoding() throws {
        // Given - Empty JSON object
        let json = """
        {}
        """.data(using: .utf8)!
        
        // When
        let item = try JSONDecoder().decode(DuckManifestItem.self, from: json)
        
        // Then - All fields should be nil
        XCTAssertNil(item.species_name)
        XCTAssertNil(item.scientific_name)
        XCTAssertNil(item.basic_description)
        XCTAssertNil(item.cool_facts)
        XCTAssertNil(item.find_this_bird)
        XCTAssertNil(item.images)
        XCTAssertNil(item.videos)
        XCTAssertNil(item.sounds)
        XCTAssertNil(item.regions)
    }
    
    func testManifestItemWithEmptyArrays() throws {
        // Given
        let json = """
        {
            "species_name": "Test Duck",
            "images": [],
            "videos": [],
            "sounds": [],
            "regions": []
        }
        """.data(using: .utf8)!
        
        // When
        let item = try JSONDecoder().decode(DuckManifestItem.self, from: json)
        
        // Then
        XCTAssertEqual(item.species_name, "Test Duck")
        XCTAssertEqual(item.images?.count, 0)
        XCTAssertEqual(item.videos?.count, 0)
        XCTAssertEqual(item.sounds?.count, 0)
        XCTAssertEqual(item.regions?.count, 0)
    }
    
    func testManifestArrayDecoding() throws {
        // Given - Array of manifest items
        let json = """
        [
            {
                "species_name": "Mallard",
                "scientific_name": "Anas platyrhynchos",
                "images": ["mallard.jpg"]
            },
            {
                "species_name": "Wood Duck",
                "scientific_name": "Aix sponsa",
                "images": ["wood_duck.jpg"]
            }
        ]
        """.data(using: .utf8)!
        
        // When
        let items = try JSONDecoder().decode([DuckManifestItem].self, from: json)
        
        // Then
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].species_name, "Mallard")
        XCTAssertEqual(items[1].species_name, "Wood Duck")
    }
    
    func testManifestItemWithSpecialCharacters() throws {
        // Given - JSON with unicode and special characters
        let json = """
        {
            "species_name": "Canard colvert",
            "scientific_name": "Anas platyrhynchos",
            "basic_description": "Description with émojis 🦆 and ñ"
        }
        """.data(using: .utf8)!
        
        // When
        let item = try JSONDecoder().decode(DuckManifestItem.self, from: json)
        
        // Then
        XCTAssertEqual(item.species_name, "Canard colvert")
        XCTAssertTrue(item.basic_description?.contains("🦆") ?? false)
        XCTAssertTrue(item.basic_description?.contains("ñ") ?? false)
    }
    
    func testManifestItemWithMultipleRegions() throws {
        // Given
        let json = """
        {
            "species_name": "Cosmopolitan Duck",
            "regions": ["North America", "South America", "Europe", "Asia", "Africa", "Oceania"]
        }
        """.data(using: .utf8)!
        
        // When
        let item = try JSONDecoder().decode(DuckManifestItem.self, from: json)
        
        // Then
        XCTAssertEqual(item.regions?.count, 6)
        XCTAssertTrue(item.regions?.contains("North America") ?? false)
        XCTAssertTrue(item.regions?.contains("Oceania") ?? false)
    }
}
