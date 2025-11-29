import SwiftUI

/// A small helper view to display a duck image from either a local asset name or a remote URL string.
struct MediaImage: View {
    let imageNameOrURL: String?
    var placeholder: Image = Image(systemName: "photo")

    var body: some View {
        Group {
            if let src = imageNameOrURL, !src.isEmpty {
                if let url = URL(string: src), url.scheme?.starts(with: "http") == true {
                    // remote image
                    if #available(iOS 15.0, *) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ZStack { ProgressView() }
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure(_):
                                placeholder
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.secondary)
                            @unknown default:
                                placeholder
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        // Fallback for older platforms: show placeholder
                        placeholder
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.secondary)
                    }
                } else {
                    // treat as local asset name
                    Image(src)
                        .resizable()
                        .scaledToFill()
                }
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
            }
        }
        .background(Color.gray.opacity(0.08))
        .clipped()
    }
}

struct MediaImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MediaImage(imageNameOrURL: nil)
                .frame(width: 120, height: 80)
            MediaImage(imageNameOrURL: "https://via.placeholder.com/300")
                .frame(width: 120, height: 80)
        }
        .padding()
    }
}
