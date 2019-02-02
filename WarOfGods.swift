// La classe mère Personnage qui régie les classes des différents personnages possible dans le jeu
class Character {
    var name: String
    var life: Int
    var attack: Int
    var heal: Int
    
    init(name: String, life: Int, attack: Int, heal: Int) {
        self.name = name
        self.life = life
        self.attack = attack
        self.heal = heal
    }
}

// La classe du guerrier
class Warrior: Character {
    
    init(name: String) {
        super.init(name: name, life: 100, attack: 10, heal: 0)
    }
    
}

// La classe du mage
class Wizard: Character {
    
    init(name: String) {
        super.init(name: name, life: 75, attack: 0, heal: 10)
    }
    
}

// La classe du colosse
class Giant: Character {
    
    init(name: String) {
        super.init(name: name, life: 200, attack: 5, heal: 0)
    }
    
}

// La classe du nain
class Dwarf: Character {
    
    init(name: String) {
        super.init(name: name, life: 50, attack: 20, heal: 0)
    }
    
}

// La classe du Joueur avec son nom et son équipe constituée
class Player {
    var name: String
    var characters: [Character]
    static var characterNames = [String]()
    
    init(name: String) {
        self.name = name
        self.characters = []
        makeTeam()
        print("\nL'équipe \(self.name) est donc composée de \(characters.count) personnages :")
        showTeam()
    }
    
    // Création d'une équipe
    func makeTeam() {
        while characters.count < 3 {
            print("\nChoisissez un personnage:"
                + "\n1. Warrior"
                + "\n2. Wizard"
                + "\n3. Giant"
                + "\n4. Dwarf")
            if let choice = readLine() {
                
                //                var characterClass: Character.Type
                //                switch choice {
                //                case "1":
                //                    characterClass = Warrior.self
                //                case "2":
                //                    characterClass = Wizard.self
                //                case "3":
                //                    characterClass = Giant.self
                //                case "4":
                //                    characterClass = Dwarf.self
                //                default:
                //                    break
                //                }
                //
                //                print("Quel est le nom du \(characterClass) ?")
                //                name = readUniqueName()
                //                var character = characterClass.init(name: name)
                //                characters ["\(name)"] = character
                
                var character: Character
                var characterName = String()
                switch choice {
                case "1" :
                    print("\nQuel est le nom du Warrior ?")
                    characterName = readUniqueName()
                    character = Warrior(name: characterName)
                    characters.append(character)
                case "2" :
                    print("\nQuel est le nom du Wizard ?")
                    characterName = readUniqueName()
                    character = Wizard(name: characterName)
                    characters.append(character)
                case "3" :
                    print("\nQuel est le nom du Giant ?")
                    characterName = readUniqueName()
                    character = Giant(name: characterName)
                    characters.append(character)
                case "4" :
                    print("\nQuel est le nom du Dwarf ?")
                    characterName = readUniqueName()
                    character = Dwarf(name: characterName)
                    characters.append(character)
                default :
                    print("Pouvez-vous répéter ?")
                    makeTeam()
                }
                Player.characterNames.append(characterName)
            }
            
        }
    }
    
    // Vérification de l'unicité du nom donné
    func readUniqueName() -> String {
        let uniqueName: String? = readLine()
        if uniqueName != nil {
            for aName in Player.characterNames {
                if uniqueName == aName {
                    print("Ce nom existe déjà. Veuillez en donner un autre.")
                    return readUniqueName()
                } else if uniqueName == "" {
                    print("Ce nom n'est pas valable. Veuillez en donner un autre.")
                    return readUniqueName()
                }
            }
        }
        return uniqueName!
    }
    
    // Présentation de l'équipe du joueur
    func showTeam() {
        var i = 1
        for character in characters {
            print("\(i). \(character.name) qui est un \(type(of: character))")
            i += 1
        }
    }
    
    // Choisir un personnage dans l'équipe du joueur et vérifie qu'il soit vivant
    func pickCharacter() -> Character {
        print("\nChoisissez un personnage.")
        showTeam()
        let choice: String? = readLine()
        if choice != "1" && choice != "2" && choice != "3" {
            print("Ce personnage n'existe pas")
            return pickCharacter()
        }
        
        let index: Int? = Int(choice!)
        if characters[index! - 1].life <= 0 {
            print("Votre personnage est mort.")
            return pickCharacter()
        }
        return characters[index! - 1]
    }
    
    // Vérifier si l'équipe est vivante
    func isTeamAlive() -> Bool {
        var life: Int = 0
        for character in characters {
            life += character.life
        }
        if life == 0 {
            return false
        } else {
            return true
        }
        // return life != 0
    }
    
}

// La classe Jeu régissant la partie et la création des joueurs, ainsi que leur nomination
class Game {
    var players: [Player]
    
    init() {
        self.players = []
        addPlayer()
        addPlayer()
        fight()
    }
    
    // Ajout d'un joueur à la partie
    func addPlayer() {
        
        //        var name: String?
        //        repeat {
        //            print("Quel est le nom du joueur \(players.count + 1) ?")
        //            name = readLine()
        //        } while name != nil && name != "";
        //
        //        players.append(Player(name: name!))
        
        print("Bonjour et bienvenu dans War Of Gods !"
            + "\nQuel est le nom du joueur \(players.count + 1) ?")
        if let name = readLine(), name != "" {
            players.append(Player(name: name))
        } else {
            print("Pouvez-vous répéter?")
            addPlayer()
        }
    }
    
    // Déroulé du combat
    func fight() {
        var character1: Character
        var character2: Character
        var i: Int = 0
        print("\nLe combat va débuter."
            + "\n\(players[i].name) veuillez commencer.")
        while players[0].isTeamAlive() && players[1].isTeamAlive() {
            character1 = players[i % 2].pickCharacter()
            if type(of: character1) == Wizard.self {
                print("\(character1.name) est un Wizard, vous pouvez donc soigner quelqu'un de votre équipe.")
                character2 = players[i % 2].pickCharacter()
                character2.life += character1.heal
                print("\(character2.name) a récupéré \(character1.heal) points de vie, il en a maintenant \(character2.life)")
            } else {
                print("\(character1.name) est un \(type(of: character1)), vous pouvez donc attaquer quelqu'un de l'équipe adverse.")
                character2 = players[(i + 1) % 2].pickCharacter()
                character2.life -= character1.attack
                print("\(character2.name) a perdu \(character1.attack) points de vie, il lui en reste \(character2.life).")
                if character2.life < 0 {
                    character2.life = 0
                    print("\(character2.name) est mort !")
                }
            }
            i += 1
        }
        if players[0].isTeamAlive() {
            print("\nL'équipe \(players[0].name) a gagné !!")
        } else {
            print("\nL'équipe \(players[1].name) a gagné !!")
        }
    }
    
}

var game = Game()

