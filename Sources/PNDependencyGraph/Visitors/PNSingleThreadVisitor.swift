final class PNSingleThreadVisitor {
    private let graph: CompiledGraph
    init(graph: CompiledGraph) {
        self.graph = graph
    }
    
    func visit(completion: (PNNode) -> Void) {
        for node in graph.nodes {
            completion(node)
        }
    }
}
