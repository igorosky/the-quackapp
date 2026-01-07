import Foundation

struct Duck: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let scientificName: String?
    let regions: [Region]
    let shortDescription: String
    let description: String
    // Optional extended text loaded from server
    var coolFacts: String?
    var findThisBird: String?
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
