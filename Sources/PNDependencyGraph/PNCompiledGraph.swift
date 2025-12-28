import Foundation

/// A compiled dependency graph.
public final class PNCompiledGraph {
    let nodes: [PNNode]
    init(nodes newNodes: [PNNode]) {
        nodes = newNodes
    }
}
