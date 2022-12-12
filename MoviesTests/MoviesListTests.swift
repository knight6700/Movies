
import Combine
import ComposableArchitecture
import XCTest
import XCTestDynamicOverlay
@testable import Movies

@MainActor
class MoviesListTests: XCTestCase {

    override  func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIntialState() async {
        let networkState: NetworkState = .loading

        let store: TestStore = TestStore(
          initialState: MoviesList.State(networkState: networkState),
          reducer: MoviesList(network: .init(\.moviesNetwork))
        )

        XCTAssertEqual(
            store.state.networkState,
            .loading
        )
    }
    
    func testSuccesData() async {
        let store: TestStore = TestStore(
            initialState: .init(),
          reducer: MoviesList(network: .init(\.moviesNetwork))
        )
        await store.send(.executeMoviesList)
        
        await store.receive(.responseMovies(.success(.mock))) {
            $0.networkState = .loaded
            $0.movieCardState.append(contentsOf: MoviesDTO.mock.results.map{$0.toDomain})
        }
        
        XCTAssertEqual(
            store.state.movieCardState.count,
            5
        )
    }
    
    func testLoadedState() async {
        
        let store: TestStore = TestStore(
            initialState: .init(),
          reducer: MoviesList(network: .init(\.moviesNetwork))
        )
        await store.send(.executeMoviesList)
        await store.receive(.responseMovies(.success(.mock))) {
            $0.networkState = .loaded
            $0.movieCardState.append(contentsOf: MoviesDTO.mock.results.map{$0.toDomain})
        }
        XCTAssertEqual(
            store.state.networkState,
            .loaded
        )
    }
}


