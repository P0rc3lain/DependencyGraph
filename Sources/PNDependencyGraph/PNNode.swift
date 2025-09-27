import Foundation

final class PNNode: @unchecked Sendable, Equatable {
    static func == (lhs: PNNode, rhs: PNNode) -> Bool {
        return lhs === rhs
    }
    
    let identifier: String
    var dependencies: [PNNode] {
        synchronization.withLock {
            unsafeDependencies
        }
    }
    private var unsafeDependencies: [PNNode] = []
    private let synchronization = NSLock()
    
    init(identifier newIdentifier: String) {
        identifier = newIdentifier
    }
    
    func addDependency(node: PNNode) {
        synchronization.withLock {
            unsafeDependencies.append(node)
        }
    }
}
