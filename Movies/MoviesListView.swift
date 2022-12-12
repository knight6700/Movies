
import SwiftUI
import ComposableArchitecture

enum NetworkState {
    case loading
    case loaded
    case error
}

struct MoviesList: ReducerProtocol {
    
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
                            content: {MovieCardView(store: $0)})
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
                }
                .ignoresSafeArea()
                .scrollIndicators(.hidden)
                .listStyle(.plain)
                .padding(.top)
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .navigation(item: viewStore.binding(get: \.selectedMovie, send: MoviesList.Action.navigationToDetails)) { _ in
                    MovieDetailsView(
                        store:                     store.scope(
                            state: \.movieDetailsState,
                            action: MoviesList.Action.movieDetailsAction
                        )
                    )

                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Movies")
        }
    }
}

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

public extension View {
    func navigation<Item, Destination: View>(
            item: Binding<Item?>,
            @ViewBuilder destination: (Item) -> Destination
        ) -> some View {
            let isActive = Binding(
                get: { item.wrappedValue != nil },
                set: { value in if !value { item.wrappedValue = nil } }
            )
            return navigation(isActive: isActive) {
                item.wrappedValue.map(destination)
            }
        }
    func navigation<Destination: View>(
            isActive: Binding<Bool>,
            @ViewBuilder destination: () -> Destination
        ) -> some View {
            overlay(
                NavigationLink(
                    destination: isActive.wrappedValue ? destination() : nil,
                    isActive: isActive,
                    label: { EmptyView() }
                )
            )
        }
}
