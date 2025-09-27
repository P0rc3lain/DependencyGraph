import Foundation

public final class PNMultithreadVisitor {
    private let graph: PNCompiledGraph
    private let queue = OperationQueue()
    public init(graph newGraph: PNCompiledGraph) {
        graph = newGraph
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = graph.nodes.count - 1
    }

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
