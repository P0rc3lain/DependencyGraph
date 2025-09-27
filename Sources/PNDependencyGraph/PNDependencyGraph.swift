import Foundation

public enum PNCompilationError: Error {
    case cycle
}

public final class PNGraph {
    private var nodes: [String: PNNode] = [:]

    public func add(identifier: String) -> PNNode {
        if let existing = nodes[identifier] { return existing }
        let node = PNNode(identifier: identifier)
        nodes[identifier] = node
        return node
    }

    public init() {

    }

    public func get(identifier: String) -> PNNode? {
        nodes[identifier]
    }

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
