//
//  Logger.swift
//  assessment
//
//  Created by Phua June Jin on 11/07/2024.
//

import Foundation
import OSLog

extension Logger {
  private static let subsystem = Bundle.main.bundleIdentifier!

  private static let general = Logger(subsystem: subsystem, category: "general")
  private static let network = Logger(subsystem: subsystem, category: "network")

  static func general(_ message: Any...) {
    Logger.network.log("[General] \(message)")
  }

  static func general(_ message: Any..., file: String = #file, method: String = #function, line: Int = #line) {
    Logger.general.log("File   : \((file as NSString).lastPathComponent) \nLine   : \(line) \nMethod : \(method) \n\n\(message)")
  }

  static func network(_ message: Any...) {
    Logger.network.log("[Network] \(message)")
  }

  static func network(_ message: Any..., file: String = #file, method: String = #function, line: Int = #line) {
    Logger.network.log("File   : \((file as NSString).lastPathComponent) \nLine   : \(line) \nMethod : \(method) \n\n\(message)")
  }
}
