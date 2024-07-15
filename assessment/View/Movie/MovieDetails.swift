//
//  MovieDetails.swift
//  assessment
//
//  Created by Phua June Jin on 13/07/2024.
//

import SwiftUI
import SwiftData

@MainActor
class vmMovieDetails: ObservableObject {
  @Bindable var movie: Movie

  @Published var state: ViewState = .idle

  @Published var poster: Image?
  @Published var backdrop: Image?

  @Published var tagline: String?
  @Published var director: String?
  @Published var topCast: [MoviePersonnel] = []

  var errorTitle = ""
  var errorMessage = ""

  var id: String {
    String(movie.id)
  }

  var score: String {
    String(format: "%.2f", movie.vote_average)
  }

  func loadPoster() async {
    guard let data = await movie.getImage(type: .poster), let image = UIImage(data: data) else { return }

    await MainActor.run {
      movie.dataPoster = data
      poster = Image(uiImage: image)
    }
  }

  func loadBackdrop() async {
    guard let data = await movie.getImage(type: .backdrop), let image = UIImage(data: data) else { return }

    await MainActor.run {
      movie.dataBackdrop = data
      backdrop = Image(uiImage: image)
    }
  }

  func details() async {
    do {
      state = .loading

      do {
        let response = try await NetworkManager.shared.fetchDetails(id: id)

        movie.merge(response)

        tagline = movie.tagline
        director = movie.director
        topCast = movie.topCast

        await loadPoster()
        await loadBackdrop()

        Container.shared.saveContext()

        state = .loaded
      } catch {
        state = .failed

        errorTitle = "Error"
        errorMessage = error.localizedDescription
      }
    }
  }

  init(movie: Movie) {
    self.movie = movie
  }
}

struct MovieDetails: View {
  @StateObject var vm: vmMovieDetails

  @State private var showAlert: Bool = false

  var body: some View {
    GeometryReader { geo in
      switch vm.state {
      case .idle, .loading:
        ProgressView()
          .controlSize(.large)
          .containerRelativeFrame([.horizontal, .vertical])

      case .loaded:
        ScrollView {
          VStack(alignment: .leading) {
            ZStack {
              if let backdrop = vm.backdrop {
                backdrop
                  .scaledToFill()
                  .frame(maxWidth: geo.size.width)
                  .frame(height: (geo.size.width > geo.size.height ? geo.size.width : geo.size.height)  * 0.33)
                  .clipped()
                  .opacity(0.5)
                  .padding(.bottom, 8)
              } else {
                Rectangle()
                  .fill(.placeholder)
                  .frame(maxWidth: .infinity)
                  .frame(height: (geo.size.width > geo.size.height ? geo.size.width : geo.size.height) * 0.33)
              }

              HStack {
                Spacer()

                if let poster = vm.poster {
                  poster
                    .resizable()
                    .frame(maxWidth: (geo.size.width > geo.size.height ? geo.size.width : geo.size.height) * 0.17)
                    .frame(height: (geo.size.width > geo.size.height ? geo.size.width : geo.size.height) * 0.25)
                    .scaledToFit()
                    .border(.primary, width: 2)
                } else {
                  Rectangle()
                    .fill(.placeholder)
                    .frame(maxWidth: (geo.size.width > geo.size.height ? geo.size.width : geo.size.height) * 0.17)
                    .frame(height: (geo.size.width > geo.size.height ? geo.size.width : geo.size.height) * 0.25)
                }

                Spacer()

                VStack {
                  Text(vm.movie.title)
                    .font(.title)
                    .bold()

                  Text(vm.tagline ?? "")
                    .italic()
                    .font(.caption)
                }

                Spacer()
              }
            }

            Group {
              HStack {
                Text("Overiew")
                  .font(.title3)
                  .fontWeight(.heavy)

                Spacer()

                Text(vm.score)
                  .bold() +
                Text(Image(systemName: "star.fill"))
                  .foregroundColor(.yellow)
              }

              Text(vm.movie.overview)
                .font(.subheadline)
                .fontWeight(.medium)

              VStack(alignment: .leading) {
                Text("Director")
                  .font(.title3)
                  .fontWeight(.heavy)

                Text(vm.director ?? "-")
                  .bold()
                  .font(.subheadline)
              }

              VStack(alignment: .leading) {
                Text("Top Billed Cast")
                  .font(.title3)
                  .fontWeight(.heavy)

                MasonryVStack(columns: 2) {
                  ForEach(vm.topCast, id: \.id) { value in
                    VStack(alignment: .leading) {
                      Text(value.name)
                        .bold()
                        .font(.subheadline)

                      Text(value.character ?? "-")
                        .font(.caption2)
                    }
                  }
                }
              }
            }
            .padding(.bottom, 8)
            .padding(.horizontal, 16)
          }
        }
        .scrollBounceBehavior(.basedOnSize, axes: [.vertical])

      case .failed:
        PulldownRefresh {
          Task { await vm.details() }
        }
      }
    }
    .navigationTitle(vm.movie.title)
    .navigationBarTitleDisplayMode(.inline)
    .alert(
      isPresented: $showAlert,
      content: {
        Alert(title: Text(vm.errorTitle), message: Text(vm.errorMessage))
      }
    )
    .onChange(of: vm.state, {
      showAlert = $1 == .failed
    })
    .onAppear {
      Task { await vm.details() }
    }
  }
}

#Preview {
  MovieDetails(vm: vmMovieDetails(movie: Movie(adult: false, backdrop_path: "/xg27NrXi7VXCGUr7MG75UqLl6Vg.jpg", genre_ids: [16, 10751, 12, 35, 18], id: 1022789, original_language: "en", original_title: "Inside Out 2", overview: "Teenager Riley's mind headquarters is undergoing a sudden demolition to make room for something entirely unexpected: new Emotions! Joy, Sadness, Anger, Fear and Disgust, who’ve long been running a successful operation by all accounts, aren’t sure how to feel when Anxiety shows up. And it looks like she’s not alone.", popularity: 10032.488, poster_path: "/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg", release_date: "2024-06-11", title: "Inside Out 2", video: false, vote_average: 7.714, vote_count: 115)))
}
