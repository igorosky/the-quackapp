import SwiftUI

struct HomeView: View {
    private let duck = Duck.sample.first!

    var body: some View {
        ZStack {
            // green gradient background (theme)
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Spacer()
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(8)
                        }
                    }
                    .padding([.horizontal, .top])

                    Text("Hello, Ornithologist!")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white) // title should be white per design
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    VStack(spacing: 16) {
                        Text("Duck of the day")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // big card
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Theme.cardBackground.opacity(0.98))
                                .frame(height: 260)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.black.opacity(0.02))
                                )

                            VStack(spacing: 8) {
                                Rectangle()
                                    .fill(Theme.bgBottom.opacity(0.8))
                                    .cornerRadius(20)
                                    .frame(height: 160)
                                    .overlay(Text("[Image of a duck").foregroundColor(.white))

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(duck.name)
                                        .font(.title3).bold()
                                    Text(duck.shortDescription)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                                .background(Color.white)
                                .cornerRadius(14)
                                .padding(.horizontal, 12)
                            }
                            .padding(.bottom, 8)
                        }

                        NavigationLink(destination: DuckDetailView(duck: duck)) {
                            Text("Check details")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(RoundedRectangle(cornerRadius: 24).fill(Theme.buttonGreen))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                        }
                    }
                    .padding(.horizontal)

                    Divider().padding(.horizontal)

                    NavigationLink(destination: DucksListView()) {
                        Text("Search for ducks")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.9)))
                            .padding(.horizontal)
                    }

                    Spacer(minLength: 40)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View { HomeView() }
}
