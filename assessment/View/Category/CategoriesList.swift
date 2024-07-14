//
//  CategoriesList.swift
//  assessment
//
//  Created by Phua June Jin on 11/07/2024.
//

import SwiftUI

class vmCategories: ObservableObject {
  var action: ((MovieCategories) -> Void)?

  init(action: ((MovieCategories) -> Void)? = nil) {
    self.action = action
  }
}

struct CategoriesList: View {
  @ObservedObject var vm: vmCategories

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(MovieCategories.allCases, id: \.rawValue) { category in
          Button {
            vm.action?(category)
          } label: {
            Category(title: category.rawValue, color: category.color)
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
    .scrollBounceBehavior(.basedOnSize, axes: [.horizontal])
  }
}

#Preview {
  CategoriesList(vm: vmCategories())
}
