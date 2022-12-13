
import Foundation
import NetworkHerizon
import ComposableArchitecture

struct MoviesListParameters: Encodable {
    var apiKey = AppEnvironment.apiKey
    var page: Int?
}

struct MoviesNetowrk {
    var load: ( _ paramters: MoviesListParameters) async throws -> MoviesDTO
    var loadDetails: (
        _ paramters: MoviesListParameters,
        _ movieId: Int
    ) async throws -> MovieDetailsDTO
}

extension MoviesNetowrk: DependencyKey {
    static var liveValue: MoviesNetowrk {
        .init {
            let data = try await NetworkService().fetch(
                type: MoviesDTO.self,
                with: .init(endpoint: "discover/movie"),
                body: $0
            )
            return data

        } loadDetails: { parameter, id in
            let data = try await NetworkService().fetch(
                type: MovieDetailsDTO.self,
                with: .init(endpoint: "movie/\(id)"),
                body: parameter
            )
            return data

        }

    }
    
    static var testValue: MoviesNetowrk {
        .init { _ in
            return .mock
        } loadDetails: { _,_ in
                .mock
            
        }
    }
    
    static var previewValue: MoviesNetowrk {
        .init { _ in
            return .mock
        } loadDetails: { _,_ in
                .mock
        }
    }
    
    static var failValue: MoviesNetowrk {
        .init { _ in
            throw NetworkError.invalidData
        } loadDetails: { _, _ in
            throw NetworkError.invalidData
        }

    }
    
    
}

extension DependencyValues {
  var moviesNetwork: MoviesNetowrk {
    get { self[MoviesNetowrk.self] }
    set { self[MoviesNetowrk.self] = newValue }
  }
}

