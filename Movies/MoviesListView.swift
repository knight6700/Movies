
import SwiftUI
import ComposableArchitecture
import SwiftUINavigation

enum NetworkState {
    case loading
    case loaded
    case error
}
// MARK: MoviesList Reducer
///  MoviesList Reducer
/// - Types:  State , Action Equatable
/// - Reducer: func to handle action and update state
struct MoviesList: ReducerProtocol {
    /// Store all values for presentation Layer
    struct State: Equatable {
        var movieCardState: IdentifiedArrayOf<MovieCard.State> = []
        var movieDetailsState: MovieDetails.State {
            get {
                .init(movie: selectedMovie)
            }
            set {}
        }
        
        var placeHolder: IdentifiedArrayOf<MovieCard.State>  {
            IdentifiedArrayOf(uniqueElements: MoviesDTO.mock.results.map {$0.toDomain})
        }
        
        var networkState: NetworkState = .loading
        var selectedMovie: Movie?
        var errorMessage = ""
        
        var totalPages: Int = 1
        var currentPage = 1
        var isHasMorePages: Bool {
            currentPage < totalPages
        }
        
        var parameters: MoviesListParameters {
            .init(page: currentPage)
        }
    }
    /// Api Dependancies to handle network fo all env live , test, preview
    @Dependency(\.moviesNetwork) var network

    enum Action: Equatable {
        case moveiCardAction(id: MovieCard.State.ID, action: MovieCard.Action)
        case onAppear
        case navigationToDetails(Movie?)
        case movieDetailsAction(MovieDetails.Action)
        case responseMovies(TaskResult<MoviesDTO>)
        case executeMoviesList
        case loadMore
    }
    
    // MARK: Reducer
    ///  body ReducerProtocol
    /// - To Handlle ation with Scopes for aniother Reducers
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .moveiCardAction(id: id, action: action):
                switch action {
                case let .onTapped(movie):
                    state.selectedMovie = movie
                    return .none
                case .onAppear:
                    guard id == state.movieCardState.last?.id ?? 0 else {return .none}
                    return .init(value: .loadMore)
                }
            case  .onAppear:
                state.selectedMovie = nil
                return .init(value: .executeMoviesList)
            case let .responseMovies(.success(movies)):
                state.networkState = .loaded
                state.totalPages = movies.totalPages
                state.movieCardState.append(contentsOf: movies.results.map{$0.toDomain})
            case let .responseMovies(.failure(error)):
                state.networkState = .error
                state.errorMessage = error.localizedDescription
            case let .navigationToDetails(model):
                state.selectedMovie = model
                return .none
            case .movieDetailsAction(_):
                return .none
            case .executeMoviesList:
                return .task { [paramters = state.parameters] in
                    await .responseMovies(
                        TaskResult {
                            try await self.network.load(paramters)
                        })
                }
            case .loadMore:
                guard state.isHasMorePages else {return .none}
                state.currentPage += 1
                return .init(value: .executeMoviesList)
            }
            return .none
        }
        .forEach(
            \.movieCardState,
             action: /Action.moveiCardAction(id:action:),
             {
                 MovieCard()
             }
        )
        // Scope MovieDetails
        Scope(state: \.movieDetailsState, action: /Action.movieDetailsAction) {
            MovieDetails()
        }
        
    }
    
    
}

struct MoviesListView: View {
    let store: StoreOf<MoviesList>
    var body: some View {
        NavigationStack {
            WithViewStore(store) { viewStore in
                List {
                    switch viewStore.networkState {
                    case .loading:
                        ForEachStore(
                            self.store
                            .scope(state:
                                \.placeHolder,
                                action: MoviesList.Action.moveiCardAction(id:action:)),
                            content: {MovieCardView(store: $0)}
                        )
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .redacted(reason: .placeholder)
                        .disabled(true)
                    case .loaded:
                        ForEachStore(
                            self.store
                            .scope(state:
                                \.movieCardState,
                                action: MoviesList.Action.moveiCardAction(id:action:)),
                            content: {MovieCardView(store: $0)})
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        if viewStore.isHasMorePages {
                            Text("Loading")
                        }

                    case .error:
                        Text(viewStore.errorMessage)
                    }
                }//: LIST
                .ignoresSafeArea()
                .scrollIndicators(.hidden)
                .listStyle(.plain)
                .padding(.top)
                .onAppear {
                    viewStore.send(.onAppear)
                }//: OnAppear
                .navigationDestination(
                    unwrapping: viewStore.binding(
                        get: \.selectedMovie,
                        send: MoviesList.Action.navigationToDetails
                    ),
                    destination: { _ in
                        MovieDetailsView(
                            store:                     store.scope(
                                state: \.movieDetailsState,
                                action: MoviesList.Action.movieDetailsAction
                            )
                        )
                    }
                )//: NavigationDestination
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Movies")
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
   static let store: StoreOf<MoviesList> =
        .init(
        initialState: .init(),
        reducer: MoviesList()
        )
    static var previews: some View {
        MoviesListView(store: store)
    }
}
#endif
