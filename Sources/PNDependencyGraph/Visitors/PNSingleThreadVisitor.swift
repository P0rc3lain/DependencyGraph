public final class PNSingleThreadVisitor {
    private let graph: PNCompiledGraph
    public init(graph: PNCompiledGraph) {
        self.graph = graph
    }

    public func visit(completion: (PNNode) -> Void) {
        for node in graph.nodes {
            completion(node)
        }
    }
}
