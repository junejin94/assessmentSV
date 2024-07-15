//
//  MovieCodable.swift
//  assessment
//
//  Created by Phua June Jin on 15/07/2024.
//

import Foundation

struct CodableMovie: Codable {
  var adult: Bool
  var backdrop_path: String?
  var belongs_to_collection: MovieCollection?
  var budget: Int?
  var genres: [MovieGenre]?
  var genre_ids: [Int]?
  var homepage: String?
  var id: Int
  var imdb_id: String?
  var origin_country: [String]?
  var original_language: String
  var original_title: String
  var overview: String
  var popularity: Double
  var poster_path: String
  var production_companies: [MovieProductionCompany]?
  var production_countries: [MovieProductionCountry]?
  var release_date: String
  var revenue: Int?
  var runtime: Int?
  var spoken_languages: [MovieSpokenLanguage]?
  var status: String?
  var tagline: String?
  var title: String
  var video: Bool
  var vote_average: Double
  var vote_count: Int
  var credits: MovieCredits?
}

struct MovieCollection: Codable {
  var id: Int
  var name: String
  var poster_path: String?
  var backdrop_path: String?
}

struct MovieGenre: Codable {
  var id: Int
  var name: String
}

struct MovieProductionCompany: Codable {
  var id: Int
  var logo_path: String?
  var name: String
  var origin_country: String
}

struct MovieProductionCountry: Codable {
  var iso_3166_1: String
  var name: String
}

struct MovieSpokenLanguage: Codable {
  var english_name: String
  var iso_639_1: String
  var name: String
}

struct MovieCredits: Codable {
  var cast: [MoviePersonnel]
  var crew: [MoviePersonnel]
}

struct MoviePersonnel: Codable {
  var adult: Bool
  var gender: Int
  var id: Int
  var known_for_department: String
  var name: String
  var original_name: String
  var popularity: Double
  var profile_path: String?
  var cast_id: Int?
  var character: String?
  var credit_id: String
  var department: String?
  var job: String?
  var order: Int?
}
