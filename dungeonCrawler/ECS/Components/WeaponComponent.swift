import Foundation

struct WeaponComponent: Component {
    var type: WeaponType
    // TODO: update to a range when StatComponet is ready, now just 0 to effectiveRange
    var manaCost: Float
    var attackSpeed: Float
    var coolDownInterval: TimeInterval
    // var coolDown: TimeInterval
    // var lastFiredAt: Float?

    init(type: WeaponType, manaCost: Float, 
         attackSpeed: Float, coolDownInterval: TimeInterval) {
        self.type = type
        self.manaCost = manaCost
        self.attackSpeed = attackSpeed
        self.coolDownInterval = coolDownInterval
    }
}

enum WeaponType: String {
    case handgun
    case sword
    case bow
}