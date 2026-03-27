import SpriteKit

/// Renders virtual joystick shapes into a SpriteKit `uiLayer`.
/// Performs coordinate conversion from UIKit-space (Input) to SpriteKit-space (HUD).
public final class SpriteKitJoystickAdapter: JoystickBackend {

    private let leftBase: SKShapeNode
    private let leftHandle: SKShapeNode
    private let rightBase: SKShapeNode
    private let rightHandle: SKShapeNode

    private let screenSize: CGSize

    public init(uiLayer: SKNode, screenSize: CGSize) {
        self.screenSize = screenSize

        // Create the shapes
        self.leftBase    = SKShapeNode(circleOfRadius: 50)
        self.leftHandle  = SKShapeNode(circleOfRadius: 22)
        self.rightBase   = SKShapeNode(circleOfRadius: 50)
        self.rightHandle = SKShapeNode(circleOfRadius: 22)

        // Initial setup for the base rings
        for base in [leftBase, rightBase] {
            base.strokeColor = SKColor(white: 1, alpha: 0.35)
            base.fillColor   = SKColor(white: 1, alpha: 0.08)
            base.lineWidth   = 2
            base.zPosition   = 100
            base.isHidden    = true
            uiLayer.addChild(base)
        }

        // Initial setup for the handles
        for handle in [leftHandle, rightHandle] {
            handle.strokeColor = SKColor(white: 1, alpha: 0.6)
            handle.fillColor   = SKColor(white: 1, alpha: 0.25)
            handle.lineWidth   = 2
            handle.zPosition   = 101
            handle.isHidden    = true
            uiLayer.addChild(handle)
        }
    }

    // MARK: - JoystickBackend

    public func updateJoystickBase(side: JoystickSide, position: CGPoint?) {
        let base = (side == .left) ? leftBase : rightBase
        updateNode(base, with: position)
    }

    public func updateJoystickHandle(side: JoystickSide, position: CGPoint?) {
        let handle = (side == .left) ? leftHandle : rightHandle
        updateNode(handle, with: position)
    }

    // MARK: - Helpers

    private func updateNode(_ node: SKNode, with uikitPos: CGPoint?) {
        if let pos = uikitPos {
            node.isHidden = false
            node.position = uiKitToSpriteKit(pos)
        } else {
            node.isHidden = true
        }
    }

    /// Converts a UIKit point (origin top-left) to SpriteKit space (origin center).
    private func uiKitToSpriteKit(_ point: CGPoint) -> CGPoint {
        CGPoint(
            x: point.x - screenSize.width  / 2,
            y: screenSize.height / 2 - point.y
        )
    }
}
