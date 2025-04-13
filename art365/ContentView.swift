import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var objectIDs: [Int] = []
    @State private var isLoading = false
    
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
                // Debug用
                Button("Fetch Object IDs") {
                    print("buttonをクリック")
                    Task {
                        isLoading = true
                        defer { isLoading = false }
                        let ids = await fetch()
                        objectIDs = ids
                    }
                }.disabled(isLoading)
                .padding()
                
                Text("Fetched Object IDs: \(objectIDs.count)")
            }
            .navigationTitle("今日の名画")
            .navigationDestination(for: Routes.self ) { route in
                route.destination()
            }
        }
    }
    
    private func fetch() async -> [Int] {
        let result = await MuseumRepository.shared.fetchObjectIds()
        switch result {
        case .success(let objectIDs):
            print("成功")
            print(objectIDs.objectIDs.prefix(10))
            return objectIDs.objectIDs
        case .failure(let error):
            print("エラー: \(error)")
            return []
        }
    }
}


#Preview {
    ContentView()
}
