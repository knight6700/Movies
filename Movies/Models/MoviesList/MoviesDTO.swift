

import Foundation
struct MoviesDTO: Codable, Equatable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}

// MARK: - Result
struct Movie: Codable, Equatable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}

// MARK: ToDomain
extension Movie {
    
    var fullPosterPath: String {
        "https://image.tmdb.org/t/p/w500" + posterPath
    }
    
    var toDomain: MovieCard.State {
        .init(
            movie: .init(
                adult: adult,
                backdropPath: backdropPath,
                genreIDS: genreIDS,
                id: id,
                originalLanguage: originalLanguage,
                originalTitle: originalTitle,
                overview: overview,
                popularity: popularity,
                posterPath: posterPath,
                releaseDate: releaseDate,
                title: title,
                video: video,
                voteAverage: voteAverage,
                voteCount: voteCount
            )
        )
    }
    
   static var mock: Self {
        Self(adult: false,
             backdropPath: "",
             genreIDS: nil,
             id: Int(arc4random_uniform(6) + 1)
             , originalLanguage: "",
             originalTitle: "",
             overview: "",
             popularity: 0,
             posterPath: "",
             releaseDate: "1994",
             title: "Movie 1",
             video: false,
             voteAverage: 0,
             voteCount: 0
        )
    }
}


// MARK: Mock
extension MoviesDTO {
    static var mock: Self {
        Self(
            page: 1,
            results: [
                .init(
                    adult: true,
                    backdropPath: "/vQsFWT2uT9VQPxxNxF273e5r5xt.jpg",
                    genreIDS: [0],
                    id: 1,
                    originalLanguage: "Lang",
                    originalTitle: "Hello",
                    overview: "When his fiancee is kidnapped by human traffickers, Roman and his ex-military brothers set out to track her down and save her before it is too late. Along the way, Roman teams up with Avery, a cop investigating human trafficking and fighting the corrupt bureaucracy that has harmful intentions.",
                    popularity: 2323,
                    posterPath: "",
                    releaseDate: "1994",
                    title: "Movie 1",
                    video: true,
                    voteAverage: 23,
                    voteCount: 1),
                .init(
                    adult: true,
                    backdropPath: "/vQsFWT2uT9VQPxxNxF273e5r5xt.jpg",
                    genreIDS: [0],
                    id: 2,
                    originalLanguage: "Lang",
                    originalTitle: "Hello",
                    overview: "When his fiancee is kidnapped by human traffickers, Roman and his ex-military brothers set out to track her down and save her before it is too late. Along the way, Roman teams up with Avery, a cop investigating human trafficking and fighting the corrupt bureaucracy that has harmful intentions.",
                    popularity: 2323,
                    posterPath: "",
                    releaseDate: "1994",
                    title: "Movie 2",
                    video: true,
                    voteAverage: 23,
                    voteCount: 1),
                .init(
                    adult: true,
                    backdropPath: "/vQsFWT2uT9VQPxxNxF273e5r5xt.jpg",
                    genreIDS: [0],
                    id: 3,
                    originalLanguage: "Lang",
                    originalTitle: "Hello",
                    overview: "When his fiancee is kidnapped by human traffickers, Roman and his ex-military brothers set out to track her down and save her before it is too late. Along the way, Roman teams up with Avery, a cop investigating human trafficking and fighting the corrupt bureaucracy that has harmful intentions.",
                    popularity: 2323,
                    posterPath: "",
                    releaseDate: "1994",
                    title: "Movie 3",
                    video: true,
                    voteAverage: 23,
                    voteCount: 1),
                .init(
                    adult: true,
                    backdropPath: "/vQsFWT2uT9VQPxxNxF273e5r5xt.jpg",
                    genreIDS: [0],
                    id: 4,
                    originalLanguage: "Lang",
                    originalTitle: "Hello",
                    overview: "When his fiancee is kidnapped by human traffickers, Roman and his ex-military brothers set out to track her down and save her before it is too late. Along the way, Roman teams up with Avery, a cop investigating human trafficking and fighting the corrupt bureaucracy that has harmful intentions.",
                    popularity: 2323,
                    posterPath: "",
                    releaseDate: "1994",
                    title: "Movie 4",
                    video: true,
                    voteAverage: 23,
                    voteCount: 1),
                .init(
                    adult: true,
                    backdropPath: "/vQsFWT2uT9VQPxxNxF273e5r5xt.jpg",
                    genreIDS: [0],
                    id: 5,
                    originalLanguage: "Lang",
                    originalTitle: "Hello",
                    overview: "When his fiancee is kidnapped by human traffickers, Roman and his ex-military brothers set out to track her down and save her before it is too late. Along the way, Roman teams up with Avery, a cop investigating human trafficking and fighting the corrupt bureaucracy that has harmful intentions.",
                    popularity: 2323,
                    posterPath: "",
                    releaseDate: "1994",
                    title: "Movie 5",
                    video: true,
                    voteAverage: 23,
                    voteCount: 1)
            ],
            totalPages: 1,
            totalResults: 5
        )
    }
}

extension String {
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYY"
        
        if let month = dateFormatter.date(from: self) {
            return month.debugDescription
        }
        return ""
    }
}
