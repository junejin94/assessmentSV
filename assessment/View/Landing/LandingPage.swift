//
//  LandingPage.swift
//  assessment
//
//  Created by Phua June Jin on 11/07/2024.
//

import Combine
import SwiftUI
import SwiftData
import OSLog

enum ViewState {
  case idle
  case loading
  case loaded
  case failed
}

@MainActor
class vmLandingPage: ObservableObject {
  var selected: MovieCategories = .nowPlaying

  var errorTitle = ""
  var errorMessage = ""

  @Published private(set) var state: ViewState = .idle
  @Published private(set) var list: [Movie] = []

  private var page = 1
  private var hasMore = true

  func load(context: ModelContext) async {
    await load(more: false, context: context)
  }

  func loadMore(context: ModelContext) async {
    await load(more: true, context: context)
  }

  private func load(more: Bool, context: ModelContext) async {
    if more {
      guard hasMore else { return }
    } else {
      page = 1
      list = []
    }

    state = .loading

    Task {
      do {
        let response = try await NetworkManager.shared.fetchCategory(category: selected, page: page)

        await MainActor.run {
          page = more ? page + 1 : 2

          var movies: [Movie] = []

          for result in response.results {
            if let movie = try? context.fetch(FetchDescriptor<Movie>(predicate: #Predicate { $0.id == result.id })).first {
              movie.merge(result)
              movies.append(movie)
            } else {
              let movie = Movie(codable: result)

              context.insert(movie)
              movies.append(movie)
            }
          }

          Container.shared.saveContext()

          hasMore = response.total_pages >= page

          if more {
            list += movies
          } else {
            list = movies
          }

          state = .loaded
        }
      } catch {
        state = .failed

        errorTitle = "Error"
        errorMessage = error.localizedDescription
      }
    }
  }
}

struct LandingPage: View {
  @Environment(\.modelContext) var modelContext

  @ObservedObject var vm: vmLandingPage

  @State private var showAlert = false
  @State private var filtering = false

  @State private var searchText = ""
  @State private var searchTerm = ""

  @Query var movies: [Movie]

  var filtered: [Movie] {
    guard !searchTerm.isEmpty else { return vm.list }

    return movies.filter({
      $0.title.range(of: searchTerm, options: .caseInsensitive) != nil
    })
  }

  let publisher = PassthroughSubject<String, Never>()

  var body: some View {
    NavigationStack {
      VStack {
        CategoriesList(vm: vmCategories {
          vm.selected = $0

          Task { await vm.load(context: modelContext) }
        })
        .padding(.bottom, 8)
        .disabled(!searchText.isEmpty)

        if filtered.isEmpty {
          if !filtering {
            PulldownRefresh {
              Task { await vm.load(context: modelContext) }
            }
          } else {
            Spacer()

            Text("Empty")

            Spacer()
          }
        } else {
          MovieList(vm: vmMovieList(list: filtered, filtering: $filtering, refresh: {
            Task { await vm.load(context: modelContext) }
          }, more: {
            Task { await vm.loadMore(context: modelContext) }
          }))
          .overlay {
            if vm.state == .loading {
              ProgressView()
                .controlSize(.large)
                .containerRelativeFrame([.horizontal, .vertical])
            }
          }
        }
      }
      .padding(.horizontal, 16)
      .navigationTitle(searchTerm.isEmpty ? vm.selected.rawValue : "Search results")
      .navigationBarTitleDisplayMode(.inline)
    }
    .disabled(vm.state == .loading)
    .searchable(text: $searchText, prompt: "Search for movies...")
    .alert(
      isPresented: $showAlert,
      content: {
        Alert(title: Text(vm.errorTitle), message: Text(vm.errorMessage))
      }
    )
    .onChange(of: vm.state, {
      showAlert = $1 == .failed
    })
    .onChange(of: searchText, { old, new in
      if old.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && new.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        searchText = ""

        return
      }

      filtering = searchText.isEmpty

      publisher.send(new)
    })
    .onReceive(publisher.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)) { text in
      searchTerm = text
      filtering = !text.isEmpty
    }
    .onAppear {
      Task { await vm.load(context: modelContext) }
    }
  }
}

#Preview {
  LandingPage(vm: vmLandingPage())
}
