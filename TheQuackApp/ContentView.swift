import SwiftUI

struct ContentView: View {
    @State private var showDuckList = false
    
    var body: some View {
        NavigationStack {
            if showDuckList {
                DuckListView(showDuckList: $showDuckList)
            } else {
                HomePage(showDuckList: $showDuckList)
            }
        }
    }
}

#Preview {
    ContentView()
}
