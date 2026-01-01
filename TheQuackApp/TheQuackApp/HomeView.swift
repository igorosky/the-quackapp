import SwiftUI

struct HomeView: View {
    @ObservedObject private var duckOfTheDay = DuckOfTheDay.shared
    private let fallbackDuck = Duck.sample.first!
    @StateObject private var store = DucksStore()

    var body: some View {
        ZStack {
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
                        // ensure we have a selection for today when this view appears
                        Color.clear.onAppear {
                            DuckOfTheDay.shared.updateIfNeeded(from: store.ducks)
                        }
                        .onReceive(store.$ducks) { ducks in
                            DuckOfTheDay.shared.updateIfNeeded(from: ducks)
                        }
                        // big card
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Theme.cardBackground.opacity(0.98))
                                .frame(height: 300)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color.black.opacity(0.02))
                                )

                            VStack(spacing: 8) {
                                MediaImage(imageNameOrURL: (duckOfTheDay.currentDuck ?? fallbackDuck).images.first)
                                    .frame(height: 200)
                                    .cornerRadius(20)
                                    .overlay(Text("[Image of a duck]").foregroundColor(.white).opacity(0))

                                VStack(alignment: .leading, spacing: 6) {
                                    let shown = duckOfTheDay.currentDuck ?? fallbackDuck
                                    Text(shown.name)
                                        .font(.title3).bold()
                                    Text(shown.shortDescription)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                                .background(Theme.cardBackground)
                                .cornerRadius(14)
                                .padding(.horizontal, 30)
                            }
                            .padding(.bottom, 8)
                        }

                        NavigationLink(destination: DuckDetailView(duck: duckOfTheDay.currentDuck ?? fallbackDuck)) {
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
                            .background(RoundedRectangle(cornerRadius: 30).fill(Theme.cardBackground))
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
