import Foundation

public final class PNNode: @unchecked Sendable, Equatable {
    public static func == (lhs: PNNode, rhs: PNNode) -> Bool {
        lhs === rhs
    }

    public let identifier: String
    public var dependencies: [PNNode] {
        synchronization.withLock {
            unsafeDependencies
        }
    }
    private var unsafeDependencies: [PNNode] = []
    private let synchronization = NSLock()

    init(identifier newIdentifier: String) {
        identifier = newIdentifier
    }

    public func addDependency(node: PNNode) {
        synchronization.withLock {
            unsafeDependencies.append(node)
        }
    }
}
