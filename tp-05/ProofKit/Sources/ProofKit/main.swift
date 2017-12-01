import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
/*<<<<<<< HEAD
//let c: Formula = "c"
let f = a && b
// NNF de f
print(f.nnf)
=======*/
let f = a && b

print(f)
//>>>>>>> upstream/master

let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)

//<<<<<<< HEAD
/*enum Fruit: BooleanAlgebra {
=======*/
enum Fruit: BooleanAlgebra {
//>>>>>>> upstream/master

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
/*<<<<<<< HEAD
print(fruityEvaluation)*/
//=======
print(fruityEvaluation)
//>>>>>>> upstream/master
