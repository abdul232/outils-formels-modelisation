import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let d: Formula = "d"
let f = a && b

print(f)

/*let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)*/


// ex 1.2
let j = (a || b) |- (a && c) || (b && c) || !c
print(j.isProvable)




// ex 1.3
let p = a => (b && a) => (c && b) => (d && c) => d |- a => d
print(p.isProvable)

// ex 1.4

let g = a => b&&b => a |- (a => b) && (b => a)
print(g.isProvable)
/*enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
print(fruityEvaluation)*/
