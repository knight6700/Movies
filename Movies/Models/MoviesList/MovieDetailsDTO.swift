//
//  MovieDetailsDTO.swift
//  Movies
//
//  Created by MahmoudFares on 11/12/2022.
//

import Foundation
struct MovieDetailsDTO: Codable, Equatable {
    let adult: Bool
    let backdropPath: String
    let belongsToCollection: String?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double
    let posterPath: String
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath
        case belongsToCollection
        case budget, genres, homepage, id
        case imdbID
        case originalLanguage
        case originalTitle
        case overview, popularity
        case posterPath
        case productionCompanies
        case productionCountries
        case releaseDate
        case revenue, runtime
        case spokenLanguages
        case status, tagline, title, video
        case voteAverage
        case voteCount
    }
}

// MARK: - Genre
struct Genre: Codable, Equatable {
    let id: Int
    let name: String
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable, Equatable {
    let englishName, name: String

    enum CodingKeys: String, CodingKey {
        case englishName
        case name
    }
}
struct ProductionCompany: Codable, Equatable {
    let id: Int?
    let logoPath: String?
    let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath
        case name
        case originCountry
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable, Equatable {
    let name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }
}


extension MovieDetailsDTO {
    var fullPosterPath: String {
        "https://image.tmdb.org/t/p/w500" + posterPath
    }
}

extension MovieDetailsDTO {
    static var mock: Self {
        Self (adult: true,
              backdropPath: "",
              belongsToCollection: "",
              budget: 2,
              genres: [],
              homepage: "wsw",
              id: 0,
              imdbID: "wwe",
              originalLanguage: "En",
              originalTitle: "Title",
              overview: "When his fiancee is kidnapped by human traffickers, Roman and his ex-military brothers set out to track her down and save her before it is too late. Along the way, Roman teams up with Avery, a cop investigating human trafficking and fighting the corrupt bureaucracy that has harmful intentions.",
              popularity: 20, posterPath: "", productionCompanies: [],
              productionCountries: [],
              releaseDate: "1994",
              revenue: 02,
              runtime: 12,
              spokenLanguages: [],
              status: "sdf",
              tagline: "",
              title: "TITLE",
              video: true,
              voteAverage: 02,
              voteCount: 2
        )
    }
}
