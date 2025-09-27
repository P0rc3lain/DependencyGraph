import Foundation

public final class PNMultithreadVisitor {
    private let graph: PNCompiledGraph
    private let queue = OperationQueue()
    public init(graph newGraph: PNCompiledGraph) {
        graph = newGraph
        queue.maxConcurrentOperationCount = graph.nodes.count
    }
    
    public func visit(completion: @escaping @Sendable (PNNode) -> Void) {
        for node in graph.nodes {
            queue.addOperation {
                completion(node)
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
}
