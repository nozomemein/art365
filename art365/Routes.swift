//
//  Routes.swift
//  art365
//
//  Created by 土方希 on 2025/04/13.
//

import SwiftUI

enum Routes: Int {
    case home
    
    @ViewBuilder
    func destination() -> some View {
        switch self {
        case .home: ContentView()
//        case .artdetail:
        }
    }
}
