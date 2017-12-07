infix operator =>: LogicalDisjunctionPrecedence

public protocol BooleanAlgebra {

    static prefix func ! (operand: Self) -> Self
    static        func ||(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
    static        func &&(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self

}

extension Bool: BooleanAlgebra {}

public enum Formula {

    /// p
    case proposition(String)

    /// ¬a
    indirect case negation(Formula)

    public static prefix func !(formula: Formula) -> Formula {
        return .negation(formula)
    }

    /// a ∨ b
    indirect case disjunction(Formula, Formula)

    public static func ||(lhs: Formula, rhs: Formula) -> Formula {
        return .disjunction(lhs, rhs)
    }

    /// a ∧ b
    indirect case conjunction(Formula, Formula)

    public static func &&(lhs: Formula, rhs: Formula) -> Formula {
        return .conjunction(lhs, rhs)
    }

    /// a → b
    indirect case implication(Formula, Formula)

    public static func =>(lhs: Formula, rhs: Formula) -> Formula {
        return .implication(lhs, rhs)
    }

    /// The negation normal form of the formula.
    public var nnf: Formula {
       // print(self)
        switch self {
        case .proposition(_):
            return self
        case .negation(let a):
            switch a {
            case .proposition(_):
                return self
            case .negation(let b):
                return b.nnf
            case .disjunction(let b, let c):
                return (!b).nnf && (!c).nnf
            case .conjunction(let b, let c):
                return (!b).nnf || (!c).nnf
            case .implication(_):
                return (!a.nnf).nnf
            }
        case .disjunction(let b, let c):
            return b.nnf || c.nnf
        case .conjunction(let b, let c):
            return b.nnf && c.nnf
        case .implication(let b, let c):
            return (!b).nnf || c.nnf
        }
    }

    /// The disjunctive normal form of the formula.
    public var dnf: Formula {
        // Write your code here ...
        // on transforme la formule en NNF
        switch self.nnf {
        case .proposition(_):
            return self.nnf
        case .negation(_):
            return self.nnf
            // si on a une disjuction on retourne le dnf des 2 parties de cette dijuction
        case .disjunction(let a, let b): //si c est une disjonction alors on retourne la disjonction des dnf des deux termes(on voit si c'est possible de les developper)
            return a.dnf || b.dnf
            // si on a une conjuction -> on regarde si on peut disribuer avec les disjunctions s'ils existent dans les 2 parties de cette conjuction
        case .conjunction(let a, let b):
            // partie gauche
            switch a.dnf {
            case .disjunction(let c, let d):
                return (b && d).dnf || (b && c).dnf
            default: break
            }
            // partie droite
            switch b.dnf {
            case .disjunction(let c, let d):
                return (c && a).dnf || (d && a).dnf
            default: break
            }
            // dans les autres cas on ne peut rien changer
            default: break
        // on aura pas d'implication car le nnf l'enlève
        }
     return self.nnf
    }

    /// The conjunctive normal form of the formula.
    public var cnf: Formula {
        // Write your code here ...
        
        // on transforme la formule en NNF
        switch self.nnf {
        case .proposition(_):
            return self.nnf
        case .negation(_):
            return self.nnf
            // si on a une conjunction on retourne le cnf des 2 parties de cette conjunction
        case .conjunction(let a, let b):
            return a.cnf && b.cnf
            // si on a une disjunction -> on regarde si on peut disribuer avec les conjunction s'ils existent dans les 2 parties de cette disjunction
        case .disjunction(let a, let b):
            // partie gauche
            switch a.cnf {
            case .conjunction(let c, let d):
                return (b || c).cnf && (b || d).cnf
            default: break
            }
            // partie droite
            switch b.cnf {
            case .conjunction(let c, let d): //pareil mais avec le terme de droite
                return (a || c).cnf && (a||d).cnf
            default: break
            }
            // dans les autres cas on ne peut rien changer
            default: break
            // on aura jamais d'implication car le nnf l'enlève
        }
         return self.nnf
}

    /// The propositions the formula is based on.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let props = f.propositions
    ///     // 'props' == Set<Formula>([.proposition("p"), .proposition("q")])
    public var propositions: Set<Formula> {
        switch self {
        case .proposition(_):
            return [self]
        case .negation(let a):
            return a.propositions
        case .disjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .conjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .implication(let a, let b):
            return a.propositions.union(b.propositions)
        }
    }

    /// Evaluates the formula, with a given valuation of its propositions.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let value = f.eval { (proposition) -> Bool in
    ///         switch proposition {
    ///         case "p": return true
    ///         case "q": return false
    ///         default : return false
    ///         }
    ///     })
    ///     // 'value' == true
    ///
    /// - Warning: The provided valuation should be defined for each proposition name the formula
    ///   contains. A call to `eval` might fail with an unrecoverable error otherwise.
    public func eval<T>(with valuation: (String) -> T) -> T where T: BooleanAlgebra {
        switch self {
        case .proposition(let p):
            return valuation(p)
        case .negation(let a):
            return !a.eval(with: valuation)
        case .disjunction(let a, let b):
            return a.eval(with: valuation) || b.eval(with: valuation)
        case .conjunction(let a, let b):
            return a.eval(with: valuation) && b.eval(with: valuation)
        case .implication(let a, let b):
            return !a.eval(with: valuation) || b.eval(with: valuation)
        }
    }

}

extension Formula: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self = .proposition(value)
    }

}

extension Formula: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

    public static func ==(lhs: Formula, rhs: Formula) -> Bool {
        switch (lhs, rhs) {
        case (.proposition(let p), .proposition(let q)):
            return p == q
        case (.negation(let a), .negation(let b)):
            return a == b
        case (.disjunction(let a, let b), .disjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.conjunction(let a, let b), .conjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.implication(let a, let b), .implication(let c, let d)):
            return (a == c) && (b == d)
        default:
            return false
        }
    }

}

extension Formula: CustomStringConvertible {

    public var description: String {
        switch self {
        case .proposition(let p):
            return p
        case .negation(let a):
            return "¬\(a)"
        case .disjunction(let a, let b):
            return "(\(a) ∨ \(b))"
        case .conjunction(let a, let b):
            return "(\(a) ∧ \(b))"
        case .implication(let a, let b):
            return "(\(a) → \(b))"
        }
    }

}
