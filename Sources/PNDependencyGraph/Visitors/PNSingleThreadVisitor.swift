public final class PNSingleThreadVisitor {
    /// A single-threaded visitor for traversing a compiled dependency graph.
    ///
    /// The `PNSingleThreadVisitor` class allows for sequential traversal of a dependency graph,
    /// executing node visits in a single thread. All nodes are processed in the order they appear
    /// in the graph.
    ///
    /// Example usage:
    /// ```swift
    /// let visitor = PNSingleThreadVisitor(graph: myGraph)
    /// visitor.visit { node in
    ///     print("Visiting node: \(node)")
    /// }
    /// ```
    private let graph: PNCompiledGraph
    
    /// Initializes a new instance of `PNSingleThreadVisitor` with the specified graph.
    ///
    /// - Parameter graph: The compiled dependency graph to visit.
    public init(graph: PNCompiledGraph) {
        self.graph = graph
    }

    /// Traverses the dependency graph, visiting each node in sequence.
    ///
    /// All nodes in the graph are visited one after another in the order they appear.
    ///
    /// - Parameter completion: A closure to be called for each visited node.
    public func visit(completion: (PNNode) -> Void) {
        for node in graph.nodes {
            completion(node)
        }
    }
}
