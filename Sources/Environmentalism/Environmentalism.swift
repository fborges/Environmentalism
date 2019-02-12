// Created by Felipe Borges on early 2019
// 🐙

import Foundation

enum EnvError: Error {
  case FileNotFound
  case InvalidFormat
}

public struct Environment {
  
  public init(filename: String = ".env") throws {
    try loadEnvironment(filename)
  }
  
  func loadEnvironment(_ filename: String) throws {
    print(FileManager.default.currentDirectoryPath)
  }
  
  
}
