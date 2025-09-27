import Foundation

final class PNMultithreadVisitor {
    private let graph: CompiledGraph
    private let queue = OperationQueue()
    init(graph newGraph: CompiledGraph) {
        graph = newGraph
        queue.maxConcurrentOperationCount = graph.nodes.count
    }
    
    func visit(completion: @escaping @Sendable (PNNode) -> Void) {
        for node in graph.nodes {
            queue.addOperation {
                completion(node)
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
}
