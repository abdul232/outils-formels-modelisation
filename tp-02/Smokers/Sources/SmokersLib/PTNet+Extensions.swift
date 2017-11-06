import PetriKit

public class MarkingGraph {
    
    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]
    
    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }
    
}

public extension PTNet {
    
    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        // Write here the implementation of the marking graph generation.
        // Initialiser les valeurs
        let markinitial = MarkingGraph(marking: marking)
        var AVisiter : [MarkingGraph] = [markinitial]
        var Visite : [MarkingGraph] = []
        // Boucler la liste à visiter
        while(!AVisiter.isEmpty) {
            let current = AVisiter.remove(at:0)
            Visite.append(current)
            // Boucle les transitions
            for transition in transitions {
                if let firedMark = transition.fire(from: current.marking) {
                    if let dejaVisiter = Visite.first(where: { $0.marking == firedMark }) {
                        current.successors[transition] = dejaVisiter
                    } else {
                        let temporaire = MarkingGraph(marking: firedMark)
                        current.successors[transition] = temporaire
                        if (!AVisiter.contains(where: { $0.marking == temporaire.marking})) {
                            AVisiter.append(temporaire)
                        }
                    }
                }
            }
        }
        return markinitial
    }
    
    
    //Le nombre d'etat du graphe
    public func count (mark: MarkingGraph) -> Int{
        var Visite = [MarkingGraph]()
        var AVisiter = [MarkingGraph]()
        
        AVisiter.append(mark)
        while let current = AVisiter.popLast() {
            Visite.append(current)
            for(_, successor) in current.successors{
                if !Visite.contains(where: {$0 === successor}) && !AVisiter.contains(where: {$0 === successor}){
                    AVisiter.append(successor)
                }
            }
        }
        return Visite.count
    }
    
    /*func counter(mark: MarkingGraph) -> Int {
        
        var seen = [MarkingGraph]
        var toVisit = [MarkingGraph]
        toVisit.append(mark)
        while let current = toVisit.popLast() {
            seen.append(current)
            for (_, successor) in mark.successors{
                if !seen.contains(where: { $0 === successor}) && !toVisit.contains(where: {$0 === successor}){
                    seen.append(successor)
                    toVisit.append(successor)
                    /*
                     par example pour faire des operations sur les noeud!!!
                     if marking.first(where: {$0.1 > 1} != nil){
                     
                     }*/
                    /*for (_, succes) in successor.successors{
                        if !seen.contains(where: { $0 === succes}){
                            seen.append(succes)
                            toVisit.append(succes)
                        }
                    }*/
                }
            }
        }
        return seen.count
    }*/
    
    // le cas des fumeurs qui fument en meme temps
    public func DeuxFumeurs(input:MarkingGraph) -> Bool{
        var Visite: [MarkingGraph] = []
        var AVisite: [MarkingGraph] = [input]
        
        while let current = AVisite.popLast(){
            Visite.append(current)
            for (place, token) in current.marking{
                var nbSmoke = 0;
                for (place, token) in current.marking {
                    if (place.name == "s1" || place.name == "s2" || place.name == "s3"){
                        nbSmoke += Int(token)
                    }
                }
                if (nbSmoke > 1) {
                    return true
                }
            }
            for (_, successor) in current.successors{
                if !Visite.contains(where: {$0 === successor}) && !AVisite.contains(where: {$0 === successor}){
                    AVisite.append(successor)
                }
            }
        }
        return false
    }
    
    
    // Avoir le meme ingredient 2 fois en meme temps
    public func DeuxIng(input:MarkingGraph) -> Bool{
        var Visite: [MarkingGraph] = []
        var AVisite: [MarkingGraph] = [input]
        
        while let current = AVisite.popLast(){
            Visite.append(current)
            for (place, token) in current.marking{
                if place.name == "p" || place.name == "m" || place.name == "t"{
                    if(token > 1){
                        return true
                    }
                }
            }
            for (_, successor) in current.successors{
                if !Visite.contains(where: {$0 === successor}) && !AVisite.contains(where: {$0 === successor}){
                    AVisite.append(successor)
                }
            }
        }
        return false
    }
    
}
    

