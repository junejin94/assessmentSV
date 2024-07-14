//
//  Movie.swift
//  assessment
//
//  Created by Phua June Jin on 10/07/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Movie: Codable, ObservableObject {
  enum CodingKeys: CodingKey {
    case adult
    case backdrop_path
    case belongs_to_collection
    case budget
    case genres
    case genre_ids
    case homepage
    case id
    case imdb_id
    case origin_country
    case original_language
    case original_title
    case overview
    case popularity
    case poster_path
    case production_companies
    case production_countries
    case release_date
    case revenue
    case runtime
    case spoken_languages
    case status
    case tagline
    case title
    case video
    case vote_average
    case vote_count
    case credits
  }

  var adult: Bool
  var backdrop_path: String?
  var belongs_to_collection: MovieCollection?
  var budget: Int?
  var genres: [MovieGenre]?
  var genre_ids: [Int]?
  var homepage: String?
  @Attribute(.unique) var id: Int
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

  @Attribute(.externalStorage) var dataPoster: Data?
  @Attribute(.externalStorage) var dataBackdrop: Data?

  init(adult: Bool, backdrop_path: String, genre_ids: [Int], id: Int, original_language: String, original_title: String, overview: String, popularity: Double, poster_path: String, release_date: String, title: String, video: Bool, vote_average: Double, vote_count: Int) {
    self.adult = adult
    self.backdrop_path = backdrop_path
    self.genre_ids = genre_ids
    self.id = id
    self.original_language = original_language
    self.original_title = original_title
    self.overview = overview
    self.popularity = popularity
    self.poster_path = poster_path
    self.release_date = release_date
    self.title = title
    self.video = video
    self.vote_average = vote_average
    self.vote_count = vote_count
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    adult                 = try container.decode(Bool.self, forKey: .adult)
    backdrop_path         = try container.decodeIfPresent(String.self, forKey: .backdrop_path)
    belongs_to_collection = try container.decodeIfPresent(MovieCollection.self, forKey: .belongs_to_collection)
    budget                = try container.decodeIfPresent(Int.self, forKey: .budget)
    genres                = try container.decodeIfPresent([MovieGenre].self, forKey: .genres)
    genre_ids             = try container.decodeIfPresent([Int].self, forKey: .genre_ids)
    homepage              = try container.decodeIfPresent(String.self, forKey: .homepage)
    id                    = try container.decode(Int.self, forKey: .id)
    imdb_id               = try container.decodeIfPresent(String.self, forKey: .imdb_id)
    origin_country        = try container.decodeIfPresent([String].self, forKey: .origin_country)
    original_language     = try container.decode(String.self, forKey: .original_language)
    original_title        = try container.decode(String.self, forKey: .original_title)
    overview              = try container.decode(String.self, forKey: .overview)
    popularity            = try container.decode(Double.self, forKey: .popularity)
    poster_path           = try container.decode(String.self, forKey: .poster_path)
    production_companies  = try container.decodeIfPresent([MovieProductionCompany].self, forKey: .production_companies)
    production_countries  = try container.decodeIfPresent([MovieProductionCountry].self, forKey: .production_countries)
    release_date          = try container.decode(String.self, forKey: .release_date)
    revenue               = try container.decodeIfPresent(Int.self, forKey: .revenue)
    runtime               = try container.decodeIfPresent(Int.self, forKey: .runtime)
    spoken_languages      = try container.decodeIfPresent([MovieSpokenLanguage].self, forKey: .spoken_languages)
    status                = try container.decodeIfPresent(String.self, forKey: .status)
    tagline               = try container.decodeIfPresent(String.self, forKey: .tagline)
    title                 = try container.decode(String.self, forKey: .title)
    video                 = try container.decode(Bool.self, forKey: .video)
    vote_average          = try container.decode(Double.self, forKey: .vote_average)
    vote_count            = try container.decode(Int.self, forKey: .vote_count)
    credits               = try container.decodeIfPresent(MovieCredits.self, forKey: .credits)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(adult, forKey: .adult)
    try container.encodeIfPresent(backdrop_path, forKey: .backdrop_path)
    try container.encodeIfPresent(belongs_to_collection, forKey: .belongs_to_collection)
    try container.encodeIfPresent(budget, forKey: .budget)
    try container.encodeIfPresent(genres, forKey: .genres)
    try container.encodeIfPresent(genre_ids, forKey: .genre_ids)
    try container.encode(homepage, forKey: .homepage)
    try container.encode(id, forKey: .id)
    try container.encode(imdb_id, forKey: .imdb_id)
    try container.encode(origin_country, forKey: .origin_country)
    try container.encode(original_language, forKey: .original_language)
    try container.encode(original_title, forKey: .original_title)
    try container.encode(overview, forKey: .overview)
    try container.encode(popularity, forKey: .popularity)
    try container.encode(poster_path, forKey: .poster_path)
    try container.encode(production_companies, forKey: .production_companies)
    try container.encode(production_countries, forKey: .production_countries)
    try container.encode(release_date, forKey: .release_date)
    try container.encode(revenue, forKey: .revenue)
    try container.encode(runtime, forKey: .runtime)
    try container.encode(spoken_languages, forKey: .spoken_languages)
    try container.encode(status, forKey: .status)
    try container.encode(tagline, forKey: .tagline)
    try container.encode(title, forKey: .title)
    try container.encode(video, forKey: .video)
    try container.encode(vote_average, forKey: .vote_average)
    try container.encode(vote_count, forKey: .vote_count)
    try container.encode(credits, forKey: .credits)
  }

  func merge(_ movie: Movie) {
    adult = movie.adult
    backdrop_path = movie.backdrop_path ?? backdrop_path
    belongs_to_collection = movie.belongs_to_collection ?? belongs_to_collection
    budget = movie.budget ?? budget
    genres = movie.genres ?? genres
    genre_ids = movie.genre_ids ?? genre_ids
    homepage = movie.homepage ?? homepage
    imdb_id = movie.imdb_id ?? imdb_id
    origin_country = movie.origin_country ?? origin_country
    original_language = movie.original_language
    original_title = movie.original_title
    overview = movie.overview
    popularity = movie.popularity
    poster_path = movie.poster_path
    production_companies = movie.production_companies ?? production_companies
    production_countries = movie.production_countries ?? production_countries
    release_date = movie.release_date
    revenue = movie.revenue ?? revenue
    runtime = movie.runtime ?? runtime
    spoken_languages = movie.spoken_languages ?? spoken_languages
    status = movie.status ?? status
    tagline = movie.tagline ?? tagline
    title = movie.title
    video = movie.video
    vote_average = movie.vote_average
    vote_count = movie.vote_count
    credits = movie.credits ?? credits
    dataPoster = movie.dataPoster ?? dataPoster
    dataBackdrop = movie.dataBackdrop ?? dataPoster
  }

  func getImage(type: ImageType) async -> Data? {
    let path: String? =
    switch type {
    case .backdrop:
      backdrop_path

    case .poster:
      poster_path
    }

    let data: Data? =
    switch type {
    case .backdrop:
      dataBackdrop

    case .poster:
      dataPoster
    }

    guard let path else { return nil }

    let image: Data? =
    if let data {
      data
    } else if let fetched = try? await NetworkManager.shared.fetchImage(path: path, type: type) {
      fetched
    } else {
      nil
    }

    return image
  }
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

extension Movie {
  @Transient var director: String? {
    credits?.crew.first(where: { $0.job == "Director" })?.name
  }

  @Transient var topCast: [MoviePersonnel] {
    guard let cast = credits?.cast else { return [] }

    let endIndex = cast.count >= 10 ? 9 : cast.count - 1

    return Array(cast[...endIndex])
  }
}
