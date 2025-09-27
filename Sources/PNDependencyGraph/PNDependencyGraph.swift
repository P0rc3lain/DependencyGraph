import Foundation

enum CompilationError: Error {
    case cycle
}

final class DependencyGraph {
    private var nodes: [String: PNNode] = [:]
    
    func addNode(_ id: String) -> PNNode {
        if let existing = nodes[id] { return existing }
        let node = PNNode(identifier: id)
        nodes[id] = node
        return node
    }
    
    func getNode(_ id: String) -> PNNode? {
        nodes[id]
    }
    
    func compile() throws -> CompiledGraph {
        var visited: Set<String> = []
        var visiting: Set<String> = []
        var result: [PNNode] = []
        
        func visit(_ node: PNNode) throws {
            if visiting.contains(node.identifier) {
                throw CompilationError.cycle
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
        
        return CompiledGraph(nodes: result)
    }
}
