//
//  ArtworkCardView.swift
//  art365
//
//  Created by 土方希 on 2025/04/13.
//

import SwiftUI

struct ArtworkCardView: View {
    let imageURL: String
    let title: String
    let artist: String
    let year: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                case .failure:
                    Color.gray
                        .overlay(Text("画像の読み込みに失敗しました").foregroundColor(.white))
                        .frame(height: 250)
                        .cornerRadius(12)
                @unknown default:
                    EmptyView()
                }
            }

            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Text(artist)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(year)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
