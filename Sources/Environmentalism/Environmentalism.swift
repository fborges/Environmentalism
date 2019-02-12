// Created by Felipe Borges
// 🐙

import Foundation

enum EnvError: Error {
  case FileNotFound
  case InvalidFormat
}

/// An abstraction that takes care of handling variables contained into your DotEnv files.
public struct Environment {
  
  private var env: [String : String] = [:]
  
  /**
   Creates an Environment with a relative file name.
   
   - Parameter fileName: the name of the DotEnv file. Defaults to `.env`.
   
   - Throws: `EnvError.FileNotFound`
              if `fileName` doesn't correspond to an existing file in the current directory path.
  */
  public init(fileName: String = ".env") throws {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath
    let filePath = "\(currentPath)/\(fileName)"
    if !fileManager.fileExists(atPath: filePath) {
      throw EnvError.FileNotFound
    }
    
    let contents = try String(contentsOfFile: filePath, encoding: .utf8)
    try loadEnvironment(contents: contents)
  }
  
  /**
   Creates an Environment with an absolute URL.
   
   - Parameter url: the absolute url that must refer to an existing DotEnv file.
   
   - Throws: `EnvError.FileNotFound`
             if `url` doesn't correspond to an existing file.
  */
  public init(url: URL) throws {
    if !FileManager.default.fileExists(atPath: url.path) {
      throw EnvError.FileNotFound
    }
    
    let contents = try String(contentsOf: url, encoding: .utf8)
    try loadEnvironment(contents: contents)
  }
  
  func loadEnvironment(_ filename: String) throws {
    print(FileManager.default.currentDirectoryPath)
  }
  
  
}
