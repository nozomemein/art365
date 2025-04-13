//
//  MuseumRepository.swift
//  art365
//
//  Created by 土方希 on 2025/04/13.
//

import Foundation

actor MuseumRepository {
    static let shared = MuseumRepository()
    
    private var isFetching = false
    
    struct ObjectIDsResponse: Decodable {
        let objectIDs: [Int]
    }
    
    struct ArtDetailResponse: Decodable {
        let objectID: Int
        let title: String
        let artistDisplayName: String
        let objectDate: String
        let primaryImageSmall: String
    }
    
    enum FetchError: Error {
        case inProgress
        case invalidResponse
    }
    
    // API経由でObject IDの一覧を取得する。重たいのでフラグチェックを挟んでいる
    // TODO: この取得したObject IDの一覧を端末に永続化しておく
    func fetchObjectIds() async -> Result<ObjectIDsResponse, FetchError> {
        if isFetching { return .failure(FetchError.inProgress) }
        
        isFetching = true
        defer { isFetching = false }
        
        do {
            let idsURL = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/search?q=painting&hasImages=true&isOnView=true")!
            let(data, _) = try await URLSession.shared.data(from: idsURL)
            let ids = try JSONDecoder().decode(ObjectIDsResponse.self, from: data)
            return .success(ids)
        } catch {
            debugPrint("Error fetching object IDs: \(error)")
            return .failure(.invalidResponse)
        }
    }
    
    func fetchArtWork(objectID: Int) async -> Result<ArtDetailResponse, FetchError> {
        do {
            let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(objectID)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let artDetail = try JSONDecoder().decode(ArtDetailResponse.self, from: data)
            return .success(artDetail)
        } catch {
            // objectIDが存在するにもかかわらず、データが取得できない場合がある
            debugPrint("Error fetching artwork detail: \(error)")
            return .failure(.invalidResponse)
        }
    }
}
