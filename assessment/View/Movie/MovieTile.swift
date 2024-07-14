//
//  MovieTile.swift
//  assessment
//
//  Created by Phua June Jin on 11/07/2024.
//

import SwiftUI

class vmMovieTile: ObservableObject {
  var movie: Movie

  let height = CGFloat.random(in: 280...320)

  @Published var poster: Image?

  var title: String {
    movie.title
  }

  var releaseDate: String {
    movie.release_date
  }

  var score: String {
    String(format: "%.2f", movie.vote_average)
  }

  init(movie: Movie) {
    self.movie = movie
  }

  func loadPoster() async {
    guard let data = await movie.getImage(type: .poster), let image = UIImage(data: data) else { return }

    await MainActor.run {
      movie.dataPoster = data
      poster = Image(uiImage: image)
    }
  }
}

struct MovieTile: View {
  @StateObject var vm: vmMovieTile

  var body: some View {
    NavigationLink {
      MovieDetails(vm: vmMovieDetails(movie: vm.movie))
    } label: {
      VStack(spacing: 8) {
        if let poster = vm.poster {
          poster
            .resizable()
            .frame(maxWidth: .infinity)
            .frame(height: vm.height)
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 20))

          VStack {
            Text(vm.title)
              .font(.subheadline)
              .fontWeight(.bold)
              .fixedSize(horizontal: false, vertical: true)
              .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
              Text(vm.releaseDate)
                .foregroundStyle(.secondary)

              Spacer()

              Text(vm.score)
                .fontWeight(.bold) +
              Text(Image(systemName: "star.fill"))
                .foregroundColor(.yellow)
            }
            .font(.footnote)
          }
        } else {
          Rectangle()
            .fill(.placeholder)
            .frame(maxWidth: .infinity)
            .frame(height: vm.height + 60)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
      }
      .frame(maxWidth: .infinity)
    }
    .buttonStyle(PlainButtonStyle())
    .onAppear {
      Task { await vm.loadPoster() }
    }
  }
}

#Preview {
  MovieTile(vm: vmMovieTile(movie: Movie(adult: false, backdrop_path: "/xg27NrXi7VXCGUr7MG75UqLl6Vg.jpg", genre_ids: [16, 10751, 12, 35, 18], id: 1022789, original_language: "en", original_title: "Inside Out 2", overview: "Teenager Riley's mind headquarters is undergoing a sudden demolition to make room for something entirely unexpected: new Emotions! Joy, Sadness, Anger, Fear and Disgust, who’ve long been running a successful operation by all accounts, aren’t sure how to feel when Anxiety shows up. And it looks like she’s not alone.", popularity: 10032.488, poster_path: "/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg", release_date: "2024-06-11", title: "Inside Out 2", video: false, vote_average: 7.714, vote_count: 115)))
}
