import Foundation

enum Region: String, CaseIterable {
    case all          = "All"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case europe       = "Europe"
    case asia         = "Asia"
    case africa       = "Africa"
    case oceania      = "Oceania"
    case antarctica   = "Antarctica"
}

struct Duck: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let scientificName: String?
    let region: Region
    let shortDescription: String
    let description: String
    // Placeholders for media
    let images: [String]
    let videos: [String]
    let sounds: [String]
    
    // Implement Hashable manually since UUID doesn't automatically get included
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Duck, rhs: Duck) -> Bool {
        lhs.id == rhs.id
    }
}

extension Duck {
    static let sample: [Duck] = [
        Duck(name: "Mallard", scientificName: "Anas platyrhynchos", region: .europe, shortDescription: "A common dabbling duck.", description: "A Mallard is a medium-sized dabbling duck that breeds throughout the temperate and subtropical Americas, Eurasia, and North Africa.", images: [], videos: [], sounds: []),
        Duck(name: "Teal", scientificName: "Anas crecca", region: .all, shortDescription: "A small dabbling duck.", description: "Teal are small freshwater ducks of the genus Anas.", images: [], videos: [], sounds: []),
        Duck(name: "Wood Duck", scientificName: "Aix sponsa", region: .northAmerica, shortDescription: "Colorful perching duck.", description: "The wood duck is a medium-sized perching duck found in North America.", images: [], videos: [], sounds: []),
        Duck(name: "Mandarin Duck", scientificName: "Aix galericulata", region: .asia, shortDescription: "Spectacular Asian waterfowl.", description: "The Mandarin Duck is a perching duck species native to East Asia.", images: [], videos: [], sounds: []),
        Duck(name: "King Eider", scientificName: "Somateria spectabilis", region: .northAmerica, shortDescription: "Large sea duck.", description: "The King Eider is a large sea duck that breeds along Northern Hemisphere Arctic coasts.", images: [], videos: [], sounds: [])
    ]
}
