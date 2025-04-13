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
            let idsURL = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects")!
            let(data, _) = try await URLSession.shared.data(from: idsURL)
            let ids = try JSONDecoder().decode(ObjectIDsResponse.self, from: data)
            return .success(ids)
        } catch {
            print("Error fetching object IDs: \(error)")
            return .failure(.invalidResponse)
        }
    }
}
