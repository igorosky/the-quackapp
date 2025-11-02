import SwiftUI

struct SettingsView: View {
    @State private var showScientific = true
    @State private var darkMode = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Settings")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    VStack(spacing: 16) {
                        Text("Display").font(.title2).bold()
                        Toggle("Scientific names", isOn: $showScientific)
                        Divider()
                        Toggle("Dark mode", isOn: $darkMode)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                    .padding(.horizontal)

                    VStack(spacing: 16) {
                        Text("Information").font(.title2).bold()
                        HStack {
                            Text("App version")
                            Spacer()
                            Text("1.0.0").foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View { SettingsView() }
}
