import SwiftUI

struct HomeView: View {
    @ObservedObject private var duckOfTheDay = DuckOfTheDay.shared
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
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        // ensure we have a selection for today when this view appears
                        Color.clear.onAppear {
                            DuckOfTheDay.shared.updateIfNeeded(from: store.ducks)
                        }
                        .onReceive(store.$ducks) { ducks in
                            DuckOfTheDay.shared.updateIfNeeded(from: ducks)
                        }
                        // Display duck card or loading/empty state
                        if store.isLoading {
                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Theme.cardBackground.opacity(0.98))
                                    .frame(height: 300)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                            .stroke(Color.black.opacity(0.02))
                                    )
                                
                                VStack(spacing: 12) {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                    Text("Loading duck...")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary.opacity(0.7))
                                }
                                .frame(maxWidth: .infinity, minHeight: 300)
                            }
                        } else if let duck = duckOfTheDay.currentDuck {
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
                                    MediaImage(imageNameOrURL: duck.images.first)
                                        .frame(height: 200)
                                        .cornerRadius(20)
                                        .overlay(Text("[Image of a duck]").foregroundColor(.white).opacity(0))

                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(duck.name)
                                            .font(.title3).bold()
                                        Text(duck.shortDescription)
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

                            NavigationLink(destination: DuckDetailView(duck: duck)) {
                                Text("Check details")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(RoundedRectangle(cornerRadius: 24).fill(Theme.buttonGreen))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                            }
                        } else {
                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Theme.cardBackground.opacity(0.98))
                                    .frame(height: 300)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                            .stroke(Color.black.opacity(0.02))
                                    )
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "bird.fill")
                                        .font(.system(size: 36, weight: .light))
                                        .foregroundColor(.secondary.opacity(0.7))
                                    Text("No ducks available")
                                        .font(.headline)
                                        .foregroundColor(.secondary.opacity(0.7))
                                    Text("Please check your server connection")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary.opacity(0.5))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, minHeight: 300)
                            }
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
