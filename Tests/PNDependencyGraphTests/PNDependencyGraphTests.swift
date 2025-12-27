@testable import PNDependencyGraph
import Testing

@Test("Many dependencies")
func manyDeps() async throws {
    let graph = PNGraph()
    let a = graph.add(identifier: "A")
    let b = graph.add(identifier: "B")
    let c = graph.add(identifier: "C")
    let d = graph.add(identifier: "D")
    let e = graph.add(identifier: "E")

    b.addDependency(node: a)
    c.addDependency(node: b)
    d.addDependency(node: b)
    e.addDependency(node: a)
    b.addDependency(node: e)

    let compiled = try graph.compile()
    #expect(compiled.nodes == [a, e, b, c, d] || compiled.nodes == [a, e, b, d, c])
}

@Test("Empty graph")
func emptyGraph() async throws {
    let graph = PNGraph()

    let compiled = try graph.compile()

    #expect(compiled.nodes == [])
}

@Test("Single node graph")
func singleNode() async throws {
    let graph = PNGraph()
    let a = graph.add(identifier: "A")

    let compiled = try graph.compile()

    #expect(compiled.nodes == [a])
}

@Test("Cycle")
func cycle() async throws {
    let graph = PNGraph()
    let a = graph.add(identifier: "A")
    let b = graph.add(identifier: "B")
    let c = graph.add(identifier: "C")

    a.addDependency(node: c)
    c.addDependency(node: b)
    b.addDependency(node: a)

    #expect(throws: PNCompilationError.self) {
        _ = try graph.compile()
    }
}
