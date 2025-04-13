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
                        )
                        .padding()
                    } else {
                        Text("No Artwork Selected")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }

                    Button("ランダムな作品を表示") {
                        Task {
                            await fetchRandomArtwork()
                        }
                    }
                    .disabled(isLoading)
                    .padding()

                    Text("取得済みID数: \(objectIDs.count)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("今日のArt")
            .navigationDestination(for: Routes.self) { route in
                route.destination()
            }
        }
    }

    private func fetchObjectIDs() async -> [Int] {
        let result = await MuseumRepository.shared.fetchObjectIds()
        switch result {
        case .success(let objectIDs):
            debugPrint("✅ Object ID取得成功")
            return objectIDs.objectIDs
        case .failure(let error):
            debugPrint("❌ Object ID取得失敗: \(error)")
            return []
        }
    }

    private func fetchRandomArtwork() async {
        isLoading = true
        defer { isLoading = false }

        if objectIDs.isEmpty {
            objectIDs = await fetchObjectIDs()
        }

        guard !objectIDs.isEmpty else {
            debugPrint("⚠️ Object IDs が空です")
            return
        }

        // 最大リトライ回数
        let maxRetry = 5
        for _ in 0..<maxRetry {
            if let randomID = objectIDs.randomElement() {
                debugPrint("🎲 ランダムID: \(randomID)")
                let result = await MuseumRepository.shared.fetchArtWork(objectID: randomID)

                switch result {
                case .success(let art):
                    artwork = art
                    return
                case .failure(let error):
                    debugPrint("⚠️ 詳細取得失敗: \(error)")
                    continue
                }
            }
        }

        debugPrint("🛑 最大リトライ回数を超えました")
    }
}
