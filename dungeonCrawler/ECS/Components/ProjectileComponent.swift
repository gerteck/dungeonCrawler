struct ProjectileComponent: Component {
    var velocity: SIMD2<Float>
    var damage: Float
    var owner: Entity
    var effectiveRange: Float
}
