import SwiftUI

struct MediaView: View {
    let title: String
    @State private var index: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            Text(title).font(.title2)

            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 220)
                .overlay(Text("[Image/Video/Audio]").foregroundColor(.white))

            HStack(spacing: 40) {
                Button("Previous") { index = max(0, index - 1) }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.6)))
                Button("Next") { index += 1 }
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
    static var previews: some View { MediaView(title: "Images") }
}
