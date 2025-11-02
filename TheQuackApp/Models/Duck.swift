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

    // synthesized Hashable is fine because all stored properties are Hashable
}