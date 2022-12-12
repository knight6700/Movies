

import SwiftUI
import ComposableArchitecture

struct MovieDetails: ReducerProtocol {
    struct State: Equatable {
        var movie: Movie?
        var title: String {
            movieDetails?.title ?? movie?.title ?? ""
        }
        
        var image: String {
            movieDetails?.fullPosterPath ??  movie?.fullPosterPath ?? ""
        }
        
        var year: String {
            movie?.releaseDate ?? ""
        }
        
        var overview: String {
            movieDetails?.overview ??  movie?.overview ?? ""
        }
        
        var movieDetails: MovieDetailsDTO?

        lazy var parameters: MoviesListParameters = {
            .init()
        }()
    }
    
    @Dependency(\.moviesNetwork) var network
    
    enum Action: Equatable {
        // Call Api for Details
        case executeDetails
        // Handle result for success and fail response
        case responseDetails(TaskResult<MovieDetailsDTO>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .executeDetails:
            // Run Task for Aysnc calling
            return .task{ [paramters = state.parameters,
                            id = state.movie?.id] in
                await .responseDetails(
                    TaskResult {
                        try await self.network.loadDetails(paramters, id ?? 0)
                    })
            }

        case let .responseDetails(.success(movieDetails)):
            state.movieDetails = movieDetails
        case let .responseDetails(.failure(error)):
            print(error)
        }
        return .none
    }
}

struct MovieDetailsView: View {
    let store: StoreOf<MovieDetails>
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            ScrollView(showsIndicators: false) {
                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    HStack {
                        Spacer()
                        PosterView(
                            image: viewStore.image,
                            width: 300,
                            height: 300
                        )
                        Spacer()
                    }//:HSTACK
                    VStack(alignment: .leading) {
                        Text(viewStore.title)
                            .fontWeight(.bold)
                        Text(viewStore.year)
                            .fontWeight(.bold)
                    }//: VSTACk
                    Text(viewStore.overview)
                }//: VSTACk
                .textSelection(.enabled)
                .padding()
            }//: ScrollView
            .onAppear {
                viewStore.send(.executeDetails)
            }
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static let store: StoreOf<MovieDetails> =
         .init(
            initialState: .init(movie: .mock),
            reducer: MovieDetails()
         )

    static var previews: some View {
        MovieDetailsView(store: store)
    }
}
