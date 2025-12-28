import Foundation

/// The main class for building and compiling dependency graphs.
///
/// This class provides methods to add nodes, define dependencies between them,
/// and compile the graph into a topologically sorted order.
public final class PNGraph {
    /// A dictionary of all nodes in the graph, keyed by their identifiers.
    private var nodes: [String: PNNode] = [:]

    /// Adds a new node to the graph with the specified identifier.
    ///
    /// If a node with this identifier already exists, it is returned instead of creating a new one.
    ///
    /// - Parameter identifier: A unique identifier for the node.
    /// - Returns: The node associated with the provided identifier.
    public func add(identifier: String) -> PNNode {
        if let existing = nodes[identifier] { return existing }
        let node = PNNode(identifier: identifier)
        nodes[identifier] = node
        return node
    }

    /// Initializes an empty dependency graph.
    public init() {

    }

    /// Retrieves a node from the graph by its identifier.
    ///
    /// - Parameter identifier: The identifier of the node to retrieve.
    /// - Returns: The node with the specified identifier, or `nil` if not found.
    public func get(identifier: String) -> PNNode? {
        nodes[identifier]
    }

    /// Compiles the dependency graph into a topologically sorted order.
    ///
    /// This method performs a depth-first search to detect cycles and generate an execution order.
    /// If a cycle is detected, it throws `PNCompilationError.cycle`.
    ///
    /// - Returns: A compiled graph containing nodes in topological order.
    /// - Throws: `PNCompilationError.cycle` if the graph contains a cycle.
    public func compile() throws -> PNCompiledGraph {
        var visited: Set<String> = []
        var visiting: Set<String> = []
        var result: [PNNode] = []

        func visit(_ node: PNNode) throws {
            if visiting.contains(node.identifier) {
                throw PNCompilationError.cycle
            }
            guard !visited.contains(node.identifier) else { return }

            visiting.insert(node.identifier)
            for dep in node.dependencies {
                try visit(dep)
            }
            visiting.remove(node.identifier)

            visited.insert(node.identifier)
            result.append(node)
        }

        for node in nodes.values {
            try visit(node)
        }

        return PNCompiledGraph(nodes: result)
    }
}
