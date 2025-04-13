import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var objectIDs: [Int] = []
    @State private var isLoading = false
    @State private var artwork: MuseumRepository.ArtDetailResponse? = nil
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let artwork = artwork {
                        ArtworkCardView(
                            imageURL: artwork.primaryImageSmall ?? "",
                            title: artwork.title,
                            artist: artwork.artistDisplayName,
                            year: artwork.objectDate
                        ).padding()
                    } else {
                        Text("No Artwork Selected")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
                // Debug用
                Button("ランダムな作品を表示") {
                    print("buttonをクリック")
                    Task {
                        isLoading = true
                        defer { isLoading = false }
                        
                        if objectIDs.isEmpty {
                            let ids = await fetchObjectIDs()
                            objectIDs = ids
                        }
                        
                        if let randomID = objectIDs.randomElement() {
                            let result = await MuseumRepository.shared.fetchArtWork(objectID: randomID)
                            switch result {
                            case .success(let fetchedArtwork):
                                artwork = fetchedArtwork
                            case .failure(let error):
                                print("詳細取得エラー: \(error)")
                            }
                        }
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
    
    private func fetchObjectIDs() async -> [Int] {
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
