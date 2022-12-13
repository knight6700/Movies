//
//  MoviesApp.swift
//  Movies
//
//  Created by MahmoudFares on 10/12/2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct MoviesApp: App {
    let store: StoreOf<MoviesList> =
        .init(
        initialState: .init(),
        reducer: MoviesList()
        )
    var body: some Scene {
        WindowGroup {
            MoviesListView(store: store)
        }
    }
}
