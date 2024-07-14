//
//  MovieList.swift
//  assessment
//
//  Created by Phua June Jin on 13/07/2024.
//

import SwiftUI

class vmMovieList: ObservableObject {
  @Published var list: [Movie]?
  @Published var spacing: Double

  @Binding var filtering: Bool

  var refresh: (() -> Void)?
  var more: (() -> Void)?

  init(list: [Movie]? = nil, spacing: Double = 12, filtering: Binding<Bool>,refresh: (() -> Void)? = nil, more: (() -> Void)? = nil) {
    self.list = list
    self.spacing = spacing
    self._filtering = filtering
    self.refresh = refresh
    self.more = more
  }
}

struct MovieList: View {
  @ObservedObject var vm: vmMovieList

  var body: some View {
    GeometryReader { geo in
      ScrollViewReader { value in
        ScrollView {
          Color.clear
            .frame(width: 0, height: 0)
            .id(0)

          LazyVStack {
            MasonryVStack(columns: Int(geo.size.width / 178), spacing: vm.spacing) {
              ForEach(vm.list ?? []) { movie in
                MovieTile(vm: vmMovieTile(movie: movie))
              }
            }

            Color.clear
              .onAppear {
                guard !vm.filtering else { return }

                vm.more?()
              }
          }
        }
        .onChange(of: vm.filtering, {
          guard $1 == true else { return }

          value.scrollTo(0)
        })
      }
      .scrollIndicators(.never)
      .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
      .refreshable {
        vm.refresh?()
      }
    }
  }
}

#Preview {
  MovieList(vm: vmMovieList(filtering: .constant(false)))
}
