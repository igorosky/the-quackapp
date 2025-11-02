import SwiftUI

struct MediaGridView: View {
    let urls: [URL]
    let mediaType: MediaType
    
    enum MediaType {
        case image
        case video
        case sound
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                ForEach(urls, id: \.self) { url in
                    MediaItemView(url: url, mediaType: mediaType)
                }
            }
            .padding()
        }
    }
}

struct MediaItemView: View {
    let url: URL
    let mediaType: MediaGridView.MediaType
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
            
            switch mediaType {
            case .image:
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .clipped()
            case .video:
                Image(systemName: "play.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            case .sound:
                Image(systemName: "speaker.wave.2.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MediaGridView(urls: [
        URL(string: "https://example.com/image1.jpg")!,
        URL(string: "https://example.com/image2.jpg")!
    ], mediaType: .image)
}