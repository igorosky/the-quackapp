import SwiftUI

struct MediaView: View {
    let title: String
    let items: [String]
    @State private var index: Int

    init(title: String, items: [String], startIndex: Int = 0) {
        self.title = title
        self.items = items
        _index = State(initialValue: startIndex)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(title).font(.title2)

            if items.isEmpty {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 220)
                    .overlay(Text("No media available").foregroundColor(.secondary))
            } else {
                MediaImage(imageNameOrURL: items[index])
                    .frame(height: 320)
                    .cornerRadius(16)
                    .clipped()
            }

            HStack(spacing: 40) {
                Button(action: { index = max(0, index - 1) }) {
                    Label("Previous", systemImage: "chevron.left")
                }
                .disabled(items.isEmpty || index == 0)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.6)))

                Button(action: { index = min((items.count - 1), index + 1) }) {
                    Label("Next", systemImage: "chevron.right")
                }
                .disabled(items.isEmpty || index >= items.count - 1)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.6)))
            }
            .foregroundColor(.black)

            Spacer()
        }
        .padding()
    }
}

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(title: "Images", items: ["https://via.placeholder.com/600", "https://via.placeholder.com/400"], startIndex: 0)
    }
}
