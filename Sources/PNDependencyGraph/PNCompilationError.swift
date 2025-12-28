import Foundation

public enum PNCompilationError: Error {
    /// Indicates that the graph contains a cycle and cannot be compiled.
    case cycle
}