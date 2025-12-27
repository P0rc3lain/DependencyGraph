import Foundation

/// A node in a dependency graph.
///
/// The `PNNode` class represents a single node within a dependency graph. Each node
/// has a unique identifier and can have dependencies on other nodes.
///
/// Example usage:
/// ```swift
/// let node = PNNode(identifier: "node1")
/// let dependency = PNNode(identifier: "node2")
/// node.addDependency(node: dependency)
/// ```
public final class PNNode: @unchecked Sendable, Equatable {
    /// Compares two `PNNode` instances for equality.
    ///
    /// Two nodes are considered equal if they are the same instance (identity comparison).
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side node to compare.
    ///   - rhs: The right-hand side node to compare.
    /// - Returns: `true` if the nodes are identical; otherwise, `false`.
    public static func == (lhs: PNNode, rhs: PNNode) -> Bool {
        lhs === rhs
    }

    /// A unique identifier for the node.
    public let identifier: String
    
    /// The dependencies of this node.
    ///
    /// This property returns an array of nodes that this node depends on.
    /// The dependencies are thread-safe and can be accessed from multiple threads.
    public var dependencies: [PNNode] {
        synchronization.withLock {
            unsafeDependencies
        }
    }
    
    /// The internal storage for dependencies.
    ///
    /// This is used internally to store the actual dependencies in a thread-safe manner.
    private var unsafeDependencies: [PNNode] = []
    
    /// A lock used to synchronize access to dependencies.
    ///
    /// This ensures that the `dependencies` property can be safely accessed from multiple threads.
    private let synchronization = NSLock()

    /// Initializes a new instance of `PNNode` with the specified identifier.
    ///
    /// - Parameter newIdentifier: A unique identifier for the node.
    init(identifier newIdentifier: String) {
        identifier = newIdentifier
    }

    /// Adds a dependency to this node.
    ///
    /// This method adds a node to the list of dependencies for this node.
    ///
    /// - Parameter node: The node that this node depends on.
    public func addDependency(node: PNNode) {
        synchronization.withLock {
            unsafeDependencies.append(node)
        }
    }
}
