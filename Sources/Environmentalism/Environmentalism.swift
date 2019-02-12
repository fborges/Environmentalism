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
  
  /**
   Parses the raw contents of the loaded file. (bare simple parser, yet to be improved and modularized).
   
   - Parameter contents: the raw string containing the contents of the DotEnv file.
   
   - Throws: `EnvError.InvalidFormat`
             if any line seems to escape the format 'KEY=VALUE'.
  */
  mutating func loadEnvironment(contents: String) throws {
    let lines = contents.split(separator:  "\n")
    try lines.forEach { (line) in
      
      // Ignore comments
      if line[line.startIndex] == "#" {
        return
      }
      
      // Ignore empty lines
      if line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
        return
      }
      
      let parts = line.split(separator: "=", maxSplits: 1)
      
      if parts.count != 2 {
        throw EnvError.InvalidFormat
      }
      
      let key = parts[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      var value = parts[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      
      if value[value.startIndex] == "\"" && value[value.index(before: value.endIndex)] == "\"" {
        value.remove(at: value.startIndex)
        value.remove(at: value.index(before: value.endIndex))
        value = value.replacingOccurrences(of:"\\\"", with: "\"")
      }
      
      env[key] = value
    }
  }
  
  /// Flushes all key-value pairs into environment variables.
  public func commit() {
    env.forEach { (key, value) in
      setenv(key, value, 1)
    }
  }
  
  /**
   Fetches value from Environment instance for a given key.
   
   - Parameter key: the key (?) <- don't document like this.
   
   - Returns: An optional String, which comes nil if no such key exists.
  */
  public subscript(key: String) -> String? {
    return env[key]
  }
  
}
