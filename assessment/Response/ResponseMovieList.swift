//
//  ResponseMovieList.swift
//  assessment
//
//  Created by Phua June Jin on 11/07/2024.
//

import Foundation

struct ResponseMovieList: Codable {
  var dates: MovieDate?
  var page: Int
  var results: [Movie]
  var total_pages: Int
  var total_results: Int
}

struct MovieDate: Codable {
  var maximum: String
  var minimum: String
}
