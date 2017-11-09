import PetriKit

public extension PTNet {

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        
        
        let transitions = self.transitions
        let departNode = CoverabilityGraph(marking: marking, successors: [:])
        var AVisite = [CoverabilityGraph]()
        var visite = [CoverabilityGraph]()
        var counter = 0
        
        // l'initialisation du premier noeud
        AVisite.append(departNode)
        
        while AVisite.count != 0 {
            let courant = AVisite.removeFirst()
            visite.append(courant)
            
            // fire les transitions et les marquages
            for trans in transitions {
                if let actMark = trans.fire(from: toPTMarking(coverabilityMarking: courant.marking)) {
                    if let dejaVisite = visite.first(where: { toPTMarking(coverabilityMarking: $0.marking) == actMark }) {
                        // rien à faire
                    } else {
                        let discovert = CoverabilityGraph(marking: toCoverabilityMarking(ptMarking: actMark), successors: [:])
                        if (!AVisite.contains(where: { $0.marking == discovert.marking })) {
                            if (!AVisite.contains(where: { discovert.marking > $0.marking })) {
                                AVisite.append(discovert)
                                courant.successors[trans] = discovert
                            }
                        }
                    }
                }
            }
        }
        return departNode
    }
    
    public func coverGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        
        
        let transitions = self.transitions
        let places = self.places
        var AVisite = [CoverabilityMarking]()
        var visite = [CoverabilityMarking]()
        var coverGraph : CoverabilityGraph
        AVisite.append(marking)
        
        var c = CoverabilityGraph(marking: marking, successors: [:])
        
        // l'initialisation du premier noeud
        while AVisite.count != 0 {
            let courant = AVisite.removeFirst()
            visite.append(courant)
            
            // fire les transitions et les marquages
            for trans in transitions {
                
                let ptMarking = toPTMarking(coverabilityMarking: courant)
                // print(ptMarking)
                if let fired = trans.fire(from: ptMarking) {
                    let coverabilityMarking = toCoverabilityMarking(ptMarking: ptMarking)
                    //   print(coverabilityMarking)
                    coverGraph = CoverabilityGraph(marking: coverabilityMarking, successors: [:])
                    
                    c.successors[trans] = coverGraph
                    
                    if let s = c.successors[trans] {
                        
                        for i in 0...visite.count-1 {
                            if (s.marking > visite[i]) {
                                for (place, _) in s.marking {
                                    if(visite[i][place]! < s.marking[place]!) {
                                        visite[i][place] = .omega
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return c
    }
    
}

public func toPTMarking(coverabilityMarking: CoverabilityMarking) -> PTMarking {
    
    var ptMarking : PTMarking = [:]
    
    for (place, token) in coverabilityMarking {
        
        switch(token) {
        case .some(let i):
            ptMarking[place] = i
            break
        case .omega:
            ptMarking[place] = 99999
            break
        }
    }
    
    return ptMarking
}

public func toCoverabilityMarking(ptMarking: PTMarking) -> CoverabilityMarking {
    
    var coverabilityMarking : CoverabilityMarking = [:]
    
    for (place, i) in ptMarking {
        
        switch(i) {
        case 99999:
            coverabilityMarking[place] = .omega
            break
        default:
            coverabilityMarking[place] = .some(i)
            break
        }
    }
    
    return coverabilityMarking
}
