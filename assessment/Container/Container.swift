//
//  Container.swift
//  assessment
//
//  Created by Phua June Jin on 10/07/2024.
//

import Foundation
import SwiftData

final class Container {
  static let shared = Container()

  private var schema = Schema([
    Movie.self
  ])

  private(set) var main: ModelContainer
  private(set) var test: ModelContainer

  private init() {
    do {
      let configurationMain = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
      let configurationTest = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

      main = try ModelContainer(for: schema, configurations: [configurationMain])
      test = try ModelContainer(for: schema, configurations: [configurationTest])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }
}
