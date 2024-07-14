//
//  Category.swift
//  assessment
//
//  Created by Phua June Jin on 11/07/2024.
//

import SwiftUI

enum MovieCategories: String, CaseIterable {
  case nowPlaying = "Now Playing"
  case popular    = "Popular"
  case topRated   = "Top Rated"
  case upcoming   = "Upcoming"

  var color: Color {
    switch self {
    case .nowPlaying:
        .mint

    case .popular:
        .red

    case .topRated:
        .yellow

    case .upcoming:
        .purple
    }
  }

  var endpoint: Endpoint {
    switch self {
    case .nowPlaying:
      .nowPlaying

    case .popular:
      .popular

    case .topRated:
      .topRated

    case .upcoming:
      .upcoming
    }
  }
}

struct Category: View {
  var title: String
  var color: Color

  var body: some View {
    ZStack {
      Color(color)

      Text(title)
        .font(.subheadline)
        .fontWeight(.bold)
    }
    .clipShape(RoundedRectangle(cornerRadius: 25))
    .frame(width: 150, height: 50)
  }
}

#Preview {
  Category(title: "Upcoming", color: .green)
}
