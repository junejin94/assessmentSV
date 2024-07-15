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
class Movie {
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

  init(adult: Bool, backdrop_path: String? = nil, belongs_to_collection: MovieCollection? = nil, budget: Int? = nil, genres: [MovieGenre]? = nil, genre_ids: [Int]? = nil, homepage: String? = nil, id: Int, imdb_id: String? = nil, origin_country: [String]? = nil, original_language: String, original_title: String, overview: String, popularity: Double, poster_path: String, production_companies: [MovieProductionCompany]? = nil, production_countries: [MovieProductionCountry]? = nil, release_date: String, revenue: Int? = nil, runtime: Int? = nil, spoken_languages: [MovieSpokenLanguage]? = nil, status: String? = nil, tagline: String? = nil, title: String, video: Bool, vote_average: Double, vote_count: Int, credits: MovieCredits? = nil, dataPoster: Data? = nil, dataBackdrop: Data? = nil) {
    self.adult = adult
    self.backdrop_path = backdrop_path
    self.belongs_to_collection = belongs_to_collection
    self.budget = budget
    self.genres = genres
    self.genre_ids = genre_ids
    self.homepage = homepage
    self.id = id
    self.imdb_id = imdb_id
    self.origin_country = origin_country
    self.original_language = original_language
    self.original_title = original_title
    self.overview = overview
    self.popularity = popularity
    self.poster_path = poster_path
    self.production_companies = production_companies
    self.production_countries = production_countries
    self.release_date = release_date
    self.revenue = revenue
    self.runtime = runtime
    self.spoken_languages = spoken_languages
    self.status = status
    self.tagline = tagline
    self.title = title
    self.video = video
    self.vote_average = vote_average
    self.vote_count = vote_count
    self.credits = credits
    self.dataPoster = dataPoster
    self.dataBackdrop = dataBackdrop
  }

  init(codable: CodableMovie) {
    self.adult = codable.adult
    self.backdrop_path = codable.backdrop_path
    self.belongs_to_collection = codable.belongs_to_collection
    self.budget = codable.budget
    self.genres = codable.genres
    self.genre_ids = codable.genre_ids
    self.homepage = codable.homepage
    self.id = codable.id
    self.imdb_id = codable.imdb_id
    self.origin_country = codable.origin_country
    self.original_language = codable.original_language
    self.original_title = codable.original_title
    self.overview = codable.overview
    self.popularity = codable.popularity
    self.poster_path = codable.poster_path
    self.production_companies = codable.production_companies
    self.production_countries = codable.production_countries
    self.release_date = codable.release_date
    self.revenue = codable.revenue
    self.runtime = codable.runtime
    self.spoken_languages = codable.spoken_languages
    self.status = codable.status
    self.tagline = codable.tagline
    self.title = codable.title
    self.video = codable.video
    self.vote_average = codable.vote_average
    self.vote_count = codable.vote_count
    self.credits = codable.credits
  }

  func merge(_ movie: CodableMovie) {
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

    let size: String =
    switch type {
    case .backdrop:
      await UIDevice.current.userInterfaceIdiom == .pad ? Configuration.ImageSize.Backdrop.original.rawValue : Configuration.ImageSize.Backdrop.w780.rawValue

    case .poster:
      Configuration.ImageSize.Poster.w780.rawValue
    }

    let image: Data? =
    if let data {
      data
    } else if let fetched = try? await NetworkManager.shared.fetchImage(path: path, type: type, size: size) {
      fetched
    } else {
      nil
    }

    return image
  }
}

extension Movie {
  @Transient var director: String? {
    credits?.crew.first(where: { $0.job == "Director" })?.name
  }

  @Transient var topCast: [MoviePersonnel] {
    guard let cast = credits?.cast else { return [] }

    let endIndex = (cast.count >= 10 ? 10 : cast.count) - 1

    return Array(cast[...endIndex])
  }
}
