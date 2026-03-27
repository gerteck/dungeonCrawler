import Foundation

/// Reads the player's health and mana each frame and pushes the values to the HUD backend.
/// Also reads the joystick positions from the input provider and pushes them to the joystick backend.
public final class HUDSystem: System {

    public let priority: Int = 95

    private weak var backend: HUDBackend?
    private weak var joystickBackend: JoystickBackend?
    private let inputProvider: InputProvider

    public init(backend: HUDBackend, joystickBackend: JoystickBackend? = nil, inputProvider: InputProvider) {
        self.backend = backend
        self.joystickBackend = joystickBackend
        self.inputProvider = inputProvider
    }

    public func update(deltaTime: Double, world: World) {
        updateStats(world: world)
        updateJoysticks()
    }

    private func updateStats(world: World) {
        guard let backend,
              let player = world.entities(with: PlayerTagComponent.self).first
        else { return }

        if let health = world.getComponent(type: HealthComponent.self, for: player) {
            let maxHP = health.value.max ?? health.value.base
            backend.updateHealthBar(current: health.value.current, max: maxHP)
        }

        if let mana = world.getComponent(type: ManaComponent.self, for: player) {
            let maxMP = mana.value.max ?? mana.value.base
            backend.updateManaBar(current: mana.value.current, max: maxMP)
        }
    }

    private func updateJoysticks() {
        guard let joystickBackend,
              let touchInput = inputProvider as? TouchJoystickInputProvider
        else {
            // Hide joysticks if using a non-touch provider (like a physical controller)
            joystickBackend?.updateJoystickBase(side: .left, position: nil)
            joystickBackend?.updateJoystickBase(side: .right, position: nil)
            return
        }

        joystickBackend.updateJoystickBase(side: .left, position: touchInput.leftBasePosition)
        joystickBackend.updateJoystickHandle(side: .left, position: touchInput.leftHandlePosition)
        
        joystickBackend.updateJoystickBase(side: .right, position: touchInput.rightBasePosition)
        joystickBackend.updateJoystickHandle(side: .right, position: touchInput.rightHandlePosition)
    }
}
