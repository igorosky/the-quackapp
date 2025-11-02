import Foundation

struct Duck: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let scientificName: String
    let description: String
    let regions: [String]
    var images: [URL]
    var videos: [URL]
    var sounds: [URL]

    // Provide explicit Hashable implementation to avoid any ambiguity for navigationDestination
    static func == (lhs: Duck, rhs: Duck) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}