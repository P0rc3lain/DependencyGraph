# DependencyGraph

A lightweight, type‑safe library for modeling and resolving directed acyclic graphs (DAGs) of dependencies.  
It provides a simple API to define nodes, establish relationships, and automatically compute an execution order that respects all dependencies.

---

## Features

- **Declarative DAG construction** – define nodes and edges with minimal boilerplate.
- **Automatic topological sorting** – get a valid execution order out of the box.
- **Cycle detection** – early validation to prevent invalid graphs.
- **Generic typing** – works with any hashable key type (String, Int, custom structs, etc.).
- **Zero‑dependency** – pure Swift, no external library overhead.
- **Testable** – comprehensive unit‑test suite included.

---

## Installation

### Swift Package Manager

Add the package to your `Package.swift`:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/P0rc3lain/DependencyGraph.git", from: "0.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "MyExecutable",
            dependencies: ["DependencyGraph", "MyPackage"]),
    ]
)
```

Then run:

```bash
swift build
```

### Xcode

1. Open your project.
2. Choose **File → Swift Packages → Add Package Dependency…**
3. Enter the URL `https://github.com/P0rc3lain/DependencyGraph.git` and select the desired version.
4. Add the library target to your target’s **Dependencies**.

---

## Usage

```swift
import DependencyGraph

// 1️⃣ Define nodes (any hashable type)
let a = Node(id: "A")
let b = Node(id: "B")
let c = Node(id: "C")

// 2️⃣ Build the graph
let graph = Graph()
graph.add(node: a)
graph.add(node: b)
graph.add(node: c)

graph.addDependency(source: a, destination: b) // A → B
graph.addDependency(source: b, destination: c) // B → C
graph.addDependency(source: a, destination: c) // A → C (optional)

// 3️⃣ Resolve execution order
if let order = graph.resolve() {
    print("Execution order: \(order.map { $0.id })")
} else {
    print("Graph contains a cycle!")
}
```

## Testing

The repository includes a comprehensive test suite:

```bash
swift test
```

All tests should pass, confirming correct cycle detection and ordering logic.

---

*Happy graph building!* 🚀
