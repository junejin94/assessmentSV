//
//  assessmentTests.swift
//  assessmentTests
//
//  Created by Phua June Jin on 10/07/2024.
//

import XCTest
@testable import assessment

final class assessmentTests: XCTestCase {
  let path = Bundle.main.path(forResource: "dummy", ofType: "json")

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testDecode() throws {
    let data = try loadMock()

    XCTAssert(!data.isEmpty)

    let decoded = try JSONDecoder().decode(ResponseMovieList.self, from: data)

    XCTAssert(decoded.results.count == 20)
  }

  private func loadMock() throws -> Data {
    let url = URL(fileURLWithPath: path!)
    let json = try Data(contentsOf: url)

    return json
  }
}
