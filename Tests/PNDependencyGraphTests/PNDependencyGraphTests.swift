import Testing
@testable import PNDependencyGraph

@Test("Many dependencies")
func manyDeps() async throws {
    let graph = DependencyGraph()
    let a = graph.addNode("A")
    let b = graph.addNode("B")
    let c = graph.addNode("C")
    let d = graph.addNode("D")
    let e = graph.addNode("E")

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
    let graph = DependencyGraph()

    let compiled = try graph.compile()
    
    #expect(compiled.nodes == [])
}

@Test("Single node graph")
func singleNode() async throws {
    let graph = DependencyGraph()
    let a = graph.addNode("A")
    
    let compiled = try graph.compile()
    
    #expect(compiled.nodes == [a])
}

@Test("Cycle")
func cycle() async throws {
    let graph = DependencyGraph()
    let a = graph.addNode("A")
    let b = graph.addNode("B")
    let c = graph.addNode("C")
    
    a.addDependency(node: c)
    c.addDependency(node: b)
    b.addDependency(node: a)
    
    #expect(throws: CompilationError.self) {
        _ = try graph.compile()
    }
}
