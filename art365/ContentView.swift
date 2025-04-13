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
                            imageURL: artwork.primaryImageSmall,
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
                    debugPrint("buttonをクリック")
                    Task {
                        isLoading = true
                        defer { isLoading = false }
                        
                        if objectIDs.isEmpty {
                            let ids = await fetchObjectIDs()
                            objectIDs = ids
                        }
                        
                        if let randomID = objectIDs.randomElement() {
                            debugPrint("ランダムなID: \(randomID)")
                            let result = await MuseumRepository.shared.fetchArtWork(objectID: randomID)
                            switch result {
                            case .success(let fetchedArtwork):
                                artwork = fetchedArtwork
                            case .failure(let error):
                                debugPrint("詳細取得エラー: \(error)")
                            }
                        }
                    }
                }.disabled(isLoading)
                    .padding()
            }
            .navigationTitle("今日のArt")
            .navigationDestination(for: Routes.self ) { route in
                route.destination()
            }
        }
    }
    
    private func fetchObjectIDs() async -> [Int] {
        let result = await MuseumRepository.shared.fetchObjectIds()
        switch result {
        case .success(let objectIDs):
            debugPrint("成功")
            debugPrint(objectIDs.objectIDs.prefix(10))
            return objectIDs.objectIDs
        case .failure(let error):
            debugPrint("エラー: \(error)")
            return []
        }
    }
}


#Preview {
    ContentView()
}
