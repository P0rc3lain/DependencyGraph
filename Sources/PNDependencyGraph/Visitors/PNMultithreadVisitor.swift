import Foundation

/// A multithreaded visitor for traversing a compiled dependency graph.
///
/// The `PNMultithreadVisitor` class allows for concurrent traversal of a dependency graph,
/// executing node visits in parallel using an operation queue. It ensures that the first
/// node is visited synchronously while all other nodes are processed in parallel.
///
/// Example usage:
/// ```swift
/// let visitor = PNMultithreadVisitor(graph: myGraph)
/// visitor.visit { node in
///     print("Visiting node: \(node)")
/// }
/// ```
public final class PNMultithreadVisitor {
    private let graph: PNCompiledGraph
    private let queue = OperationQueue()

    /// Initializes a new instance of `PNMultithreadVisitor` with the specified graph.
    ///
    /// - Parameter newGraph: The compiled dependency graph to visit.
    public init(graph newGraph: PNCompiledGraph) {
        graph = newGraph
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = graph.nodes.count - 1
    }

    /// Traverses the dependency graph, visiting each node.
    ///
    /// The first node in the graph is visited synchronously, while all other nodes
    /// are processed concurrently in an operation queue.
    ///
    /// - Parameter completion: A closure to be called for each visited node.
    public func visit(completion: @Sendable @escaping (PNNode) -> Void) {
        guard let first = graph.nodes.first else {
            return
        }
        for node in graph.nodes.dropFirst() {
            queue.addOperation {
                completion(node)
            }
        }
        completion(first)
        queue.waitUntilAllOperationsAreFinished()
    }
}
