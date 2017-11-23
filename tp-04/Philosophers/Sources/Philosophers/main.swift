import PetriKit
import PhilosophersLib

/*do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

do {
    let philosophers = lockFreePhilosophers(n: 3)
    // let philosophers = lockablePhilosophers(n: 3)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }
}*/
/*do {
    enum Ingredients{
        case p,t,m
    }
    enum Smokers{
        case s1,s2,s3
    }
    enum Ref {
        case arbitr
    }
    enum Types {
        case ingredients(Ingredients)
        case smokers(Smokers)
        case reference(Ref)
    }
    
    func ing(binding: PredicateTransition<Ingredients>.Binding) -> Ingredients{
        
        
    }
    let s = PredicateTransition<Types>(
        preconditions: [
            PredicateArc(place: "i", label: [.variable("x"), .variable("y")]),
            PredicateArc(place:"s", label: [.variable("s")]),
            ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
            ])
}
*/

do {
    let model = lockFreePhilosophers()
    let graph = model.markingGraph(from: model.initialMarking!)
    print("nous avons", graph!.count, "marquage dans un modèle non bloquable")
}


do {
    let model = lockablePhilosophers()
    let graph = model.markingGraph(from: model.initialMarking!)
    print("nous avons", graph!.count, "marquage dans un modèle bloquable")
}


do {
    let model = lockablePhilosophers()
    let graph = model.markingGraph(from: model.initialMarking!)
    print("Voilà un exemple faites attention à vos yeux ")
     for g in graph! {
         print(g.marking)
     }
}
