//
//  PulldownRefresh.swift
//  assessment
//
//  Created by Phua June Jin on 15/07/2024.
//

import SwiftUI

struct PulldownRefresh: View {
  var action: (() -> Void)?

  var body: some View {
    GeometryReader { geo in
      ScrollView {
        Color.clear
          .frame(width: geo.size.width, height: geo.size.height)
      }
      .refreshable {
        action?()
      }
    }
  }
}

#Preview {
  PulldownRefresh()
}
