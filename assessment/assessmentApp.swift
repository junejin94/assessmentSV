//
//  assessmentApp.swift
//  assessment
//
//  Created by Phua June Jin on 10/07/2024.
//

import SwiftUI
import SwiftData

@main
struct assessmentApp: App {
  var body: some Scene {
    WindowGroup {
      LandingPage(vm: vmLandingPage())
    }
    .modelContainer(Container.shared.main)
  }
}
