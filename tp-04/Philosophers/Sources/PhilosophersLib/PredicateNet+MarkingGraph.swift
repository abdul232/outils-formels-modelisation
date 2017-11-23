extension PredicateNet {

    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {
        // Write your code here ...

        // Note that I created the two static methods `equals(_:_:)` and `greater(_:_:)` to help
        // you compare predicate markings. You can use them as the following:
        //
        //     PredicateNet.equals(someMarking, someOtherMarking)
        //     PredicateNet.greater(someMarking, someOtherMarking)
        //
        // You may use these methods to check if you've already visited a marking, or if the model
        // is unbounded.
        var transitions = Array(self.transitions)
        let departNode = PredicateMarkingNode<T>(marking: marking)
        var AVisite = [departNode]
        var Visite = [departNode]
        // on parcoure tous les marquages
        while AVisite.count != 0 {
            // voir un element du marquage
            let courant = AVisite[0]
            for trans in 0...(transitions.count-1) {
                // créer les binding
                let bindings = transitions[trans].fireableBingings(from: courant.marking)
                var NouveauBinding : PredicateBindingMap<T> = [:]
                // on parcoure les binding
                for binding in bindings {
                    // on le tire si c'est possible
                    if let newFire = transitions[trans].fire(from: courant.marking, with: binding) {
                        let newMark = PredicateMarkingNode<T>(marking: newFire)
                        // voir si le graphe est bounded
                        if Visite.contains(where: { PredicateNet.greater(newMark.marking, $0.marking)}) {
                            return nil
                        }
                        // si le marquage n'esiste pas on le rajoute pour le voir
                        if !Visite.contains(where: { PredicateNet.equals($0.marking, newMark.marking)}) {
                            AVisite.append(newMark)
                            Visite.append(newMark)
                            NouveauBinding[binding] = newMark
                            //rajouter un successor
                            courant.successors.updateValue(NouveauBinding, forKey: transitions[trans])
                        }
                            // sinon on cherche ses successors
                        else {
                            for MARK in Visite {
                                if PredicateNet.equals(MARK.marking, newMark.marking){
                                    NouveauBinding[binding] = MARK
                                    // et on les rajoute
                                    courant.successors.updateValue(NouveauBinding, forKey: transitions[trans])
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
            // on enlève le marquage qu'on viens de le voir
            AVisite.remove(at: 0)
        }
        return departNode
    }
    
    
    
    
    
    
    
    
    
    

    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard tokens.filter({ $0 == t }).count == rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.filter({ $0 == t }).count >= rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return hasGreater
    }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
