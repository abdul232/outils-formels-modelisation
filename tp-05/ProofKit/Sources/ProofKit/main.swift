import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
//<<<<<<< HEAD
//let c: Formula = "c"
let f = !(a && (b || c))
let g = ((!a || b && c) && a)
let i = (a => b) || !(a && c)
// NNF de f
//print(f)
print("9eme séance d'exercice")
print("Exercice 2.1")
print ("forme négative NNF:")
print(f.nnf)
print("Forme conjoctive CNF:")
print(f.cnf)
print("Forme disjoctive DNF:")
print (f.dnf)
print("Exercice 2.2")
print ("forme négative NNF:")
print(i.nnf)
print("Forme conjoctive CNF:")
print(i.cnf)
print("Forme disjoctive DNF:")
print(i.dnf)
print("Exercice 2.3")
print ("forme négative NNF:")
print(g.nnf)
print("Forme conjoctive CNF:")
print(g.cnf)
print("Forme disjoctive DNF:")
print(g.dnf)


//=======*/
//let f = a && b


//>>>>>>> upstream/master

/*let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)*/

//<<<<<<< HEAD
/*enum Fruit: BooleanAlgebra {
=======*/
/*enum Fruit: BooleanAlgebra {
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
//<<<<<<< HEAD
//print(fruityEvaluation)*/
//=======
//print(fruityEvaluation)
//>>>>>>> upstream/master
