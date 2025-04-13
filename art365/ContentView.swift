import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ArtworkCardView(
                        imageURL: "https://images.metmuseum.org/CRDImages/ep/web-large/DT1567.jpg",
                        title: "Madonna and Child",
                        artist: "Giovanni Bellini",
                        year: "1480"
                    )
                    .padding()
                }
            }
            .navigationTitle("今日の名画")
            .navigationDestination(for: Routes.self ) { route in
                route.destination()
            }
        }
    }
}


#Preview {
    ContentView()
}
