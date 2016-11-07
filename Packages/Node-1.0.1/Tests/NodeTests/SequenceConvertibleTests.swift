//
//  SequenceConvertibleTests.swift
//  Node
//
//  Created by Logan Wright on 7/20/16.
//
//

import XCTest
import Node

class TestInitializable: NodeInitializable {
    let node: Node

    required init(node: Node, in context: Context) {
        self.node = node
    }
}

final class Foo: NodeConvertible {
    var node: Node
    var contextMakeNode: Context?

    init(node: Node, in context: Context) throws {
        self.node = node
    }

    func makeNode(context: Context = EmptyNode) throws -> Node {
        self.contextMakeNode = context
        return node
    }
}

class SequenceConvertibleTests: XCTestCase {
    static let allTests = [
        ("testSequence", testSequence),
        ("testDictionary", testDictionary),
        ("testArrayConvert", testArrayConvert),
        ("testSetConvert", testSetConvert),
    ]

    func testSequence() throws {
        let ints: [Int] = [1,2,3,4,5]
        let node = try ints.makeNode()
        XCTAssert(node == .array([1,2,3,4,5]))

        let representables = ints.map { $0 as NodeRepresentable }
        let node2 = try representables.makeNode()
        XCTAssert(node2 == .array([1,2,3,4,5]))

        let models = try ints.converted(to: [TestInitializable].self)
        let backInts = models.map { $0.node } .flatMap { $0.int }
        XCTAssert(backInts == ints)

        let models2 = try representables.converted(to: [TestInitializable].self)
        let backInts2 = models2.map { $0.node } .flatMap { $0.int }
        XCTAssert(backInts2 == ints)


        // This tests whether the context is passed to the sequence
        let foo1 = try Foo(node: [
            "hello"
        ])
        let foo2 = try Foo(node: [
            "goodbye"
        ])

        XCTAssertNil(foo1.contextMakeNode)
        XCTAssertNil(foo2.contextMakeNode)

        let context = ["isContext": true]

        let _ = try [foo1, foo2].makeNode(context: context)

        guard let foo1Context = foo1.contextMakeNode as? [String: Bool], 
            let foo2Context = foo1.contextMakeNode as? [String: Bool] else {
            XCTFail()
            return
        }

        XCTAssert(foo1Context == context)
        XCTAssert(foo2Context == context)

    }

    func testDictionary() throws {
        let dict: [String: String] = [
            "key": "val",
            "hi": "world"
        ]
        let node = try dict.makeNode()
        XCTAssert(node == ["key": "val", "hi": "world"])

        let model = try dict.converted(to: TestInitializable.self)
        XCTAssert(model.node["key"]?.string == "val")
        XCTAssert(model.node["hi"]?.string == "world")
    }

    func testArrayConvert() throws {
        let ints = try [Int](node: Node.array([1,2,3,4,"5"]))
        XCTAssert(ints == [1,2,3,4,5])

        let one = try [Int](node: 1)
        XCTAssert(one == [1])

        let strings = ["1", "2", "3", "4", "5"]
        let collected = try strings.map(to: Int.self)
        XCTAssert(collected == [1,2,3,4,5])

        let collectedMixed = try [1, 2, "3", "4", 5].map(to: Int.self)
        XCTAssert(collectedMixed == [1,2,3,4,5])
    }

    func testSetConvert() throws {
        let ints = try Set<Int>(node: Node.array([1,2,3,4,"5"]))
        XCTAssert(ints == [1,2,3,4,5])

        let one = try Set<Int>(node: 1)
        XCTAssert(one == [1])

        let strings = ["1", "2", "3", "4", "5"]
        let collected = try Set<Int>(node: Node(node: strings))
        XCTAssert(collected == [1,2,3,4,5])

        let collectedMixed = try [1, 2, "3", "4", 5].map(to: Int.self).set
        XCTAssert(collectedMixed == [1,2,3,4,5])
    }

    func testRepresentableDictionary() throws {
        let node = try Node(node: [
            "hello": 52,
        ])
        XCTAssertEqual(node, .object(["hello": 52]))

        let foo = try Foo(node: [
            "hello": 52
        ])
        XCTAssertEqual(foo.node, .object(["hello": 52]))

        let fooWithNil = try Foo(node: [
            "hello": nil
        ])
        XCTAssertEqual(fooWithNil.node, .object(["hello": .null]))
    }

    func testRepresentableArray() throws {
        let node = try Node(node: [
            "hello",
        ])
        XCTAssertEqual(node, .array(["hello"]))


        let foo = try Foo(node: [
            "hello"
        ])
        XCTAssertEqual(foo.node, .array(["hello"]))

        let fooWithNil = try Foo(node: [
            nil
        ])
        XCTAssertEqual(fooWithNil.node, .array([.null]))

    }
}
