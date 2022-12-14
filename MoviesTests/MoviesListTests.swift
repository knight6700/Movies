
import Combine
import ComposableArchitecture
import XCTest
import XCTestDynamicOverlay
@testable import Movies
@testable import NetworkHerizon

@MainActor
class MoviesListTests: XCTestCase {

    override  func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_initialload_withViewAppearance_dataLoaded() async {
        let store: TestStore = TestStore(
            initialState: .init(),
          reducer: MoviesList(network: .init(\.moviesNetwork))
        )
        
        let response = MoviesDTO.mock
        
        await store.send(.onAppear)
        await store.receive(.loadMovies)
        await store.receive(.moviesResponse(.success(response))) {
            $0.networkState = .loaded
            $0.totalPages = 1
            $0.movieCardState.append(contentsOf: response.results.map { $0.toDomain })
        }
    }
    
    func test_initialload_withViewAppearance_dataFailed() async {
        let store: TestStore = TestStore(
            initialState: .init(),
          reducer: MoviesList(network: .init(\.moviesNetwork))
        )
        store.dependencies.moviesNetwork = .failValue
        
        await store.send(.onAppear)
        await store.receive(.loadMovies)
        await store.receive(.moviesResponse(.failure(NetworkError.invalidData))) {
            $0.networkState = .loaded
            $0.alertState = AlertState(
                title: TextState("Alert!"),
                message: TextState("The operation couldn’t be completed. (NetworkHerizon.NetworkError error 3.)")
              )
        }
    }
    
    func testLoadMore() async {
        let store: TestStore = TestStore(
            initialState: .init(),
          reducer: MoviesList(network: .init(\.moviesNetwork))
        )
        let response = MoviesDTO.mock
        await store.send(.onAppear)
        await store.receive(.loadMovies)
        await store.receive(.moviesResponse(.success(response))) {
            $0.networkState = .loaded
            $0.totalPages = 1
            $0.movieCardState.append(contentsOf: response.results.map { $0.toDomain })
        }
        await store.send(.moveiCardAction(id: response.results.last?.id ?? 0, action: .onAppear))
        await store.receive(.loadMore)
        await store.send(.loadMovies)
        await store.receive(.moviesResponse(.success(response)))
    }
    
}



