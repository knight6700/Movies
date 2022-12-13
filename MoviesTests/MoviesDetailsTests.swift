
import Combine
import ComposableArchitecture
import XCTest
import XCTestDynamicOverlay
@testable import Movies

@MainActor
final class MoviesDetailsTests: XCTestCase {

    override  func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testIntialState() async {
        let store: TestStore = TestStore(
            initialState: .init(movie: .mock),
          reducer: MovieDetails()
        )
        XCTAssertNotNil(store.state.movie)
    }
    
    func testSuccesData() async {
        let store: TestStore = TestStore(
            initialState: .init(movie: .mock),
          reducer: MovieDetails()
        )
        await store.send(.executeDetails)
        await store.receive(.responseDetails(.success(.mock))) {
            $0.movieDetails = .mock
        }
        XCTAssertNotNil(store.state.movieDetails)
    }
    
    func testTitle() async {
        let store: TestStore = TestStore(
            initialState: .init(movie: .mock),
          reducer: MovieDetails()
        )
        XCTAssertEqual(store.state.title, "Movie 1")
    }
    
    func testYear() async {
        let store: TestStore = TestStore(
            initialState: .init(movie: .mock),
          reducer: MovieDetails()
        )
        XCTAssertEqual(store.state.year, "1994")
    }
}
