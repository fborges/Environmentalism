import XCTest
@testable import Environmentalism

class EnvironmentalismTests: XCTestCase {
  var env: Environment!
  
  let fileName = "mock.env"
  var path: String { return "\(FileManager.default.currentDirectoryPath)/\(fileName)"}
  let mockEnv =
  """
  # comment

  COLOR=BLACK
  FUR=GALLOWS
  EYES=1
  """
  
  override func setUp() {
    FileManager.default.createFile(atPath: path, contents: mockEnv.data(using: .utf8), attributes: nil)
    self.env = try? Environment(fileName: fileName)
  }
  
  func testInitializeWithFileName() {
    XCTAssertNoThrow(try Environment(fileName: fileName))
  }
  
  func testInitializeWithURL() {
    let url = URL(fileURLWithPath: path)
    XCTAssertNoThrow(try Environment(url: url))
  }
  
  func testInitializeWithWrongFileName() {
    XCTAssertThrowsError(try Environment())
  }
  
  func testInitializeWithWrongURL() {
    XCTAssertThrowsError(try Environment(url: URL(fileURLWithPath: "\(FileManager.default.currentDirectoryPath)/mockerrado.env")))
  }
  
  func testSizeOfDictionary() {
    guard let environment = env else { XCTFail("Unexpected error."); return }
    XCTAssertEqual(environment.all().count, 3)
  }
  
  func testValue1() {
    guard let environment = env else { XCTFail("Unexpected error."); return }
    XCTAssertEqual(environment["COLOR"], "BLACK")
  }
  
  func testValue3() {
    guard let environment = env else { XCTFail("Unexpected error."); return }
    XCTAssertEqual(environment["EYES"], "1")
  }
  
  func testWrongKey() {
    guard let environment = env else { XCTFail("Unexpected error."); return }
    XCTAssertNil(environment["DOG"])
  }
  
  func testCommit() {
    guard let environment = env else { XCTFail("Unexpected error."); return }
    environment.commit()
    guard let value = getenv("COLOR"), let stringValue = String(validatingUTF8: value) else {
      XCTFail("Could not get/parse environment variable.")
      return
    }
    XCTAssertEqual(stringValue, "BLACK")
  }
}
