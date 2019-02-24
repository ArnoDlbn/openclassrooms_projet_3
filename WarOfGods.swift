// The class which runs all different types of characters in the game
class Character {
    var name: String
    var life: Int
    var attack: Int
    var heal: Int
    var weapon: Weapon?
    var element: Element
    
    init(name: String, life: Int, attack: Int, heal: Int, element: Element) {
        self.name = name
        self.life = life
        self.attack = attack
        self.heal = heal
        self.element = element
    }
    
    var realAttack: Int {
        return self.attack + (self.weapon?.attack ?? 0)
    }
    
    var realHeal: Int {
        return self.heal + (self.weapon?.heal ?? 0)
    }
}

// The warrior class
class Warrior: Character {
    
    init(name: String, element: Element) {
        super.init(name: name, life: 100, attack: 10, heal: 0, element: element)
    }
}

// The wizard class
class Wizard: Character {
    
    init(name: String, element: Element) {
        super.init(name: name, life: 75, attack: 0, heal: 10, element: element)
    }
}

// The giant class
class Giant: Character {
    
    init(name: String, element: Element) {
        super.init(name: name, life: 200, attack: 5, heal: 0, element: element)
    }
}

// The dwarf class
class Dwarf: Character {
    
    init(name: String, element: Element) {
        super.init(name: name, life: 50, attack: 20, heal: 0, element: element)
    }
}

// The class which runs all different types of weapons in the game
class Weapon {
    var attack: Int
    var heal: Int
    var name: String
    
    init(name: String, attack: Int, heal: Int) {
        self.attack = attack
        self.heal = heal
        self.name = name
    }
}

// The class of weapons that attack
class AttackingWeapon: Weapon {
    
    init(name: String, attack: Int) {
        super.init(name: name, attack: attack, heal: 0)
    }
}

// The class of weapons that heal
class HealingWeapon: Weapon {
    
    init(name: String, heal: Int) {
        super.init(name: name, attack: 0, heal: heal)
    }
}

// The enumeration which controls the elements of the characters and their interactions
enum Element {
    case fire
    case air
    case water
    case earth
    
    var lowestElements: [Element] {
        switch self {
        case .fire: return [.air]
        case .air: return [.earth]
        case .water: return [.fire]
        case .earth: return [.water]
        }
    }
    
    var highestElements: [Element] {
        switch self {
        case .earth: return [.air]
        case .fire: return [.water]
        case .air: return [.fire]
        case .water: return [.earth]
        }
    }
    
    // Allows to know the coefficient of strenght between two elements for healing
    func coefficientToApplyOnHeal(_ element: Element) -> Double {
        if self == element {
            return 1.2
        } else {
            return 1.0
        }
    }
    
    // Allows to know the coefficient of strenght between two elements for attacking
    func coefficientToApplyOnAttack(_ element: Element) -> Double {
        if self.lowestElements.contains(element) {
            return 1.2
        } else if self.highestElements.contains(element) {
            return 0.8
        } else {
            return 1.0
        }
    }
}

// The class which stores all the weapons in a chest
class Chest {
    var toothbrush: AttackingWeapon
    var sword: AttackingWeapon
    var axe: AttackingWeapon
    var toothpick: HealingWeapon
    var staff: HealingWeapon
    var orb: HealingWeapon
    var weapons: [Weapon]
    
    init() {
        self.toothbrush = AttackingWeapon(name: "une brosse à dent", attack: 1)
        self.sword = AttackingWeapon(name: "une épée", attack: 5)
        self.axe = AttackingWeapon(name: "une hache", attack: 10)
        self.toothpick = HealingWeapon(name: "un cure dent", heal: 1)
        self.staff = HealingWeapon(name: "un bâton", heal: 5)
        self.orb = HealingWeapon(name: "un orbe", heal: 10)
        self.weapons = [toothbrush, sword, axe, toothpick, staff, orb]
        
    }
    
    // Picks a random weapon
    func pickWeapon() -> Weapon {
        let weapon = weapons.randomElement()
        print("Le coffre contient \(weapon!.name)")
        return weapon!
    }
}

// The class with all the informations and functions about the player and his team of characters
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
    
    // Team building
    func makeTeam() {
        while characters.count < 3 {
            print("\nChoisissez un personnage:"
                + "\n1. Guerrier"
                + "\n2. Magicien"
                + "\n3. Géant"
                + "\n4. Nain")
            if let choice = readLine() {
                var character: Character
                var characterName = String()
                var characterElement = Element.fire
                switch choice {
                case "1" :
                    print("\nQuel est le nom du Guerrier ?")
                    characterName = readUniqueName()
                    characterElement = chooseElement()
                    character = Warrior(name: characterName, element: characterElement)
                    characters.append(character)
                case "2" :
                    print("\nQuel est le nom du Magicien ?")
                    characterName = readUniqueName()
                    characterElement = chooseElement()
                    character = Wizard(name: characterName, element: characterElement)
                    characters.append(character)
                case "3" :
                    print("\nQuel est le nom du Géant ?")
                    characterName = readUniqueName()
                    characterElement = chooseElement()
                    character = Giant(name: characterName, element: characterElement)
                    characters.append(character)
                case "4" :
                    print("\nQuel est le nom du Nain ?")
                    characterName = readUniqueName()
                    characterElement = chooseElement()
                    character = Dwarf(name: characterName, element: characterElement)
                    characters.append(character)
                default :
                    print("Pouvez-vous répéter ?")
                    makeTeam()
                }
                Player.characterNames.append(characterName)
            }
        }
    }
    
    // Checks the uniqueness of the given name
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
    
    // Picks an element
    func chooseElement() -> Element {
        var element = Element.fire
        print("\nDe quel élément voulez-vous qu'il soit ?"
            + "\n1. Feu"
            + "\n2. Eau"
            + "\n3. Air"
            + "\n4. Terre")
        if let choice = readLine() {
            switch choice {
            case "1" :
                element = .fire
            case "2" :
                element = .water
            case "3" :
                element = .air
            case "4" :
                element = .earth
            default :
                print("Pouvez-vous répéter ?")
                return chooseElement()
            }
        }
        return element
    }
    
    // Introduces the player's team
    func showTeam() {
        var i = 1
        for character in characters {
            print("\(i). \(character.name) est un \(type(of: character)) de type \(character.element)")
            i += 1
        }
    }
    
    // Picks a character in the player's team and checks if he is alive
    func pickCharacter() -> Character {
        print("\n\(self.name), choisissez un personnage.")
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
    
    // Checks if the team is alive
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
    }
}

// La classe Jeu régissant la partie, la création des joueurs, leur nomination et le combat avec l'apparition aléatoire d'un coffre
class Game {
    var players: [Player]
    
    init() {
        self.players = []
        print("Bonjour et bienvenu dans War Of Gods !")
        addPlayer()
        addPlayer()
        fight()
    }
    
    // Adds a player to the game
    func addPlayer() {
        print("\nQuel est le nom du joueur \(players.count + 1) ?")
        if let name = readLine(), name != "" {
            players.append(Player(name: name))
        } else {
            print("Pouvez-vous répéter?")
            addPlayer()
        }
    }
    
    // All stages of the fight
    func fight() {
        var character1: Character
        var character2: Character
        var chest: Chest?
        var weapon: Weapon
        var i: Int = 0
        print("\nLe combat va débuter."
            + "\n\(players[i].name) veuillez commencer.")
        while players[0].isTeamAlive() && players[1].isTeamAlive() {
            character1 = players[i % 2].pickCharacter()
            chest = makeChestAppear()
            if chest != nil {
                weapon = chest!.pickWeapon()
                if type(of: weapon) == HealingWeapon.self && type(of: character1) == Wizard.self {
                    character1.weapon = weapon
                    print("\n\(character1.name) s'équipe de l'arme."
                        + "\nSon pouvoir de soigner s'élève maintenant à \(character1.realHeal) points de vie.")
                } else if type(of: weapon) == AttackingWeapon.self && type(of: character1) != Wizard.self {
                    character1.weapon = weapon
                    print("\n\(character1.name) s'équipe de l'arme."
                        + "\nSon attaque s'élève maintenant à \(character1.realAttack) points d'attaque.")
                }
            }
            if type(of: character1) == Wizard.self {
                print("\n\(character1.name) est un Magicien, vous pouvez donc soigner quelqu'un de votre équipe.")
                character2 = players[i % 2].pickCharacter()
                let heal = Int(Double(character1.realHeal) * character1.element.coefficientToApplyOnHeal(character2.element))
                character2.life += heal
                print("\(character2.name) a récupéré \(heal) points de vie, il en a maintenant \(character2.life)")
            } else {
                print("\n\(character1.name) est un \(type(of: character1)), vous pouvez donc attaquer quelqu'un de l'équipe adverse.")
                character2 = players[(i + 1) % 2].pickCharacter()
                let damage = Int(Double(character1.realAttack) * character1.element.coefficientToApplyOnAttack(character2.element))
                character2.life -= damage
                print("\(character2.name) a perdu \(damage) points de vie, il lui en reste \(character2.life).")
                
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
    
    // Random appearance of a chest
    func makeChestAppear() -> Chest? {
        let random = [0,1]
        let randomElement = random.randomElement()
        if randomElement == 1 {
            print("\nUn coffre apparaît !")
            return Chest()
        } else {
            print("\nPas de coffre pour cette fois ci ...")
            return nil
        }
    }
}

var game = Game()
