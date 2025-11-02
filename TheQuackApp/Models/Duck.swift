import Foundation

struct Duck: Identifiable {
    let id: UUID = UUID()
    let name: String
    let scientificName: String
    let description: String
    let regions: [String]
    var images: [URL]
    var videos: [URL]
    var sounds: [URL]
}