import TaskManagerLib

let taskManager = createTaskManager()

// Show here an example of sequence that leads to the described problem.
// For instance:
let create = taskManager.transitions.filter{$0.name == "create"}[0]
let spawn = taskManager.transitions.filter{$0.name == "spawn"}[0]
let exec = taskManager.transitions.filter{$0.name == "exec"}[0]
let success = taskManager.transitions.filter{$0.name == "success"}[0]
let fail = taskManager.transitions.filter{$0.name == "fail"}[0]
let taskPool = taskManager.places.filter{$0.name == "taskPool"}[0]
let processPool = taskManager.places.filter{$0.name == "processPool"}[0]
let inProgress = taskManager.places.filter{$0.name == "inProgress"}[0]
// le cas où il nous reste des processus à se debarasser dans inProgress sans avoir des tâches pour les lier et mon exemmple consiste à avoir 2 processus et 1 seule tâche
let m1 = success.fire(from: [taskPool: 1, processPool: 0, inProgress: 2])
/*
 exemple détaillé
let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
let m2 = spawn.fire(from: m1!)
let m3 = spawn.fire(from: m2!)
let m4 = exec.fire(from: m3!)
let m5 = exec.fire(from: m4!)
let m6 = success.fire(from: m5!)
 print(m6!)
 */
print(m1!)
print(" ")
print(" ")


let correctTaskManager = createCorrectTaskManager()

// Show here that you corrected the problem.
// For instance:

let creates = correctTaskManager.transitions.filter{$0.name == "create"}[0]
let spawns = correctTaskManager.transitions.filter{$0.name == "spawn"}[0]
let execs = correctTaskManager.transitions.filter{$0.name == "exec"}[0]
let successs = correctTaskManager.transitions.filter{$0.name == "success"}[0]
let fails = correctTaskManager.transitions.filter{$0.name == "fail"}[0]
let taskPools = correctTaskManager.places.filter{$0.name == "taskPool"}[0]
let processPools = correctTaskManager.places.filter{$0.name == "processPool"}[0]
let inProgresss = correctTaskManager.places.filter{$0.name == "inProgress"}[0]
let complementaryPlaces = correctTaskManager.places.filter{$0.name == "complementaryPlace"}[0]
// ma correction consiste à rajouter une place complemantaire pour répartir les processus d'une manière qu'elles restent pas bloquées dans inProgress
// dans notre exemple précéednt la processus bloqué dans inProgress et qui n'a plus de taches à s'associer elle se lie avec la tache stockée dans la place complimantaire.
let l1 = fails.fire(from: [taskPools: 0, processPools: 0, inProgresss: 1, complementaryPlaces: 1])
print(l1!)
/*
exemple détaillé
let l1 = creates.fire(from: [taskPools: 0, processPools: 0, inProgresss: 0, complementaryPlaces: 0])
print(l1!)
let l2 = spawns.fire(from: l1!)
print(l2!)
let l3 = spawns.fire(from: l2!)
print(l3!)
let l4 = execs.fire(from: l3!)
print(l4!)
let l5 = execs.fire(from: l4!)
print(l5!)
let l6 = successs.fire(from: l5!)
print(l6!)
let l7 = fails.fire(from: l6!)
print(l7!)
*/

