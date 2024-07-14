//
//  NetworkManager.swift
//  assessment
//
//  Created by Phua June Jin on 10/07/2024.
//

import Foundation
import OSLog

final class NetworkManager {
  static let shared = NetworkManager()

  private init() {}

  func fetchDetails(id: String, append_to_response: String? = "credits", language: String? = "en-US") async throws -> Movie {
    let endpoint = Endpoint.details(id)
    let queryItems = [
      URLQueryItem(name: "language", value: language),
      URLQueryItem(name: "append_to_response", value: append_to_response)
    ]

    let request = NetworkRequest(host: .api, endpoint: endpoint, queryItems: queryItems)
    let data = try await fetch(request: request)

    return try JSONDecoder().decode(Movie.self, from: data)
  }

  func fetchCategory(category: MovieCategories, language: String? = "en-US", page: Int = 1, region: String? = "MY") async throws -> ResponseMovieList {
    let endpoint = category.endpoint
    let queryItems = [
      URLQueryItem(name: "language", value: language),
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "region", value: region)
    ]

    let request = NetworkRequest(host: .api, endpoint: endpoint, queryItems: queryItems)
    let data = try await fetch(request: request)

    return try JSONDecoder().decode(ResponseMovieList.self, from: data)
  }

  func fetchImage(path: String, type: ImageType, size: String? = "w780") async throws -> Data? {
    switch type {
    case .backdrop:
      guard Configuration.ImageSize.Backdrop(size: size) != nil else { return nil }

    case .poster:
      guard Configuration.ImageSize.Poster(size: size) != nil else { return nil }
    }

    let endpoint = Endpoint.custom("/t/p/" + (size ?? "w780") + path)

    let request = NetworkRequest(host: .image, endpoint: endpoint)
    let data = try await fetch(request: request)

    return data
  }
}

extension NetworkManager {
  private func fetch(request: NetworkRequest) async throws -> Data {
    guard let urlRequest = request.urlRequest else { throw NetworkError.invalidRequest }

    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
      switch statusCode {
      case 300...599:
        Logger.network(NetworkError.unsuccessfulRequest.localizedDescription)

        throw NetworkError.unsuccessfulRequest

      default:
        break
      }
    }

    return data
  }
}

struct NetworkRequest {
  var scheme: String = "https"
  var host: NetworkHost
  var endpoint: Endpoint
  var httpMethod: String = "GET"
  var queryItems: [URLQueryItem]?
  var timeoutInterval: TimeInterval = 10.0

  private var url: URL? {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host.rawValue
    components.path = endpoint.path
    components.queryItems = queryItems

    return components.url
  }

  var urlRequest: URLRequest? {
    guard let url else { return nil }

    let headers = [
      "accept": "application/json",
      "Authorization": ""
    ]

    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
    request.httpMethod = httpMethod
    request.allHTTPHeaderFields = headers

    return request
  }
}

enum NetworkHost: String {
  case api = "api.themoviedb.org"
  case image = "image.tmdb.org"
}

enum Endpoint {
  case nowPlaying
  case popular
  case topRated
  case upcoming
  case details(String)
  case custom(String)

  var path: String {
    switch self {
    case .nowPlaying:
      "/3/movie/now_playing"

    case .popular:
      "/3/movie/popular"

    case .topRated:
      "/3/movie/top_rated"

    case .upcoming:
      "/3/movie/upcoming"

    case .details(let id):
      "/3/movie/\(id)"

    case .custom(let string):
      string
    }
  }
}

enum ImageType {
  case backdrop
  case poster
}

enum Configuration {
  enum ImageSize {
    enum Backdrop: String {
      case w300
      case w780
      case w1280
      case original

      init?(size: String?) {
        guard let size, let valid = Configuration.ImageSize.Backdrop(rawValue: size) else { return nil }

        self = valid
      }
    }

    enum Logo: String {
      case w45
      case w92
      case w154
      case w185
      case w300
      case w500
      case original

      init?(size: String?) {
        guard let size, let valid = Configuration.ImageSize.Logo(rawValue: size) else { return nil }

        self = valid
      }
    }

    enum Poster: String {
      case w92
      case w154
      case w185
      case w342
      case w500
      case w780
      case original

      init?(size: String?) {
        guard let size, let valid = Configuration.ImageSize.Poster(rawValue: size) else { return nil }

        self = valid
      }
    }

    enum Profile: String {
      case w45
      case w185
      case w632
      case original

      init?(size: String?) {
        guard let size, let valid = Configuration.ImageSize.Profile(rawValue: size) else { return nil }

        self = valid
      }
    }

    enum Still: String {
      case w92
      case w185
      case w300
      case original

      init?(size: String?) {
        guard let size, let valid = Configuration.ImageSize.Still(rawValue: size) else { return nil }

        self = valid
      }
    }
  }
}

enum NetworkError: LocalizedError {
  case invalidRequest
  case unsuccessfulRequest

  var errorDescription: String? {
    switch self {
    case .invalidRequest:
      return "Invalid Request"

    case .unsuccessfulRequest:
      return "Encountered some network issues.\nPlease try again later."
    }
  }
}
