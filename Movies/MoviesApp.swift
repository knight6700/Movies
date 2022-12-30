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
    @StateObject var network: Monitor = .init()
    @State var showAlert: Bool = false
    
    var body: some Scene {
        WindowGroup {
            MoviesListView(store: store)
                .onChange(of: network) { newValue in
                    switch newValue.status {
                    case .connected:
                        showAlert = false
                    case .disconnected:
                        showAlert = true
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Your internet connection is too slow."), dismissButton: .default(Text("ok")))
                }

        }
    }
}
