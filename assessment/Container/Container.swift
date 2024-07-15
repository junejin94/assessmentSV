//
//  Container.swift
//  assessment
//
//  Created by Phua June Jin on 10/07/2024.
//

import Foundation
import SwiftData
import OSLog

final class Container {
  static let shared = Container()

  private var schema = Schema([
    Movie.self
  ])

  private(set) var container: ModelContainer

  private init() {
    do {
      let configurationMain = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

      container = try ModelContainer(for: schema, configurations: [configurationMain])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }

  func saveContext() {
    Task { await save() }
  }

  @MainActor private func save() async {
    do {
      try container.mainContext.save()
    } catch {
      Logger.general(error)
    }
  }
}
