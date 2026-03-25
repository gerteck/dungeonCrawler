---
title: "Dungeon Generation"
description: "Architecture and design rationale for procedural dungeon generation."
---

# Dungeon Generation

## Design Overview

The dungeon generation system produces a procedurally-connected set of rooms for each level. It is organized into three independent layers:

```
Layer 1 — DungeonLayoutStrategy    Whole Dungeon: topology (which rooms exist, how they connect)
Layer 2 — RoomInteriorStrategy     Room Specific: geometry (walls, floor, obstacles per room)
Layer 3 — LevelOrchestrator        Orchestration: ECS lifecycle (load, build, transition, cleanup)
```

Each layer is an extension point. Swapping the layout algorithm or interior style means providing a new conforming type—the orchestration layer (`LevelOrchestrator`) requires no changes.

### Top-Level Organization

| File | Layer | Role |
|---|---|---|
| `Level/Layout/DungeonLayoutStrategy.swift` | Framework | Protocol: produces a `DungeonGraph` |
| `Level/Interior/RoomInteriorStrategy.swift` | Framework | Protocol: fills one room with ECS geometry |
| `Level/Structure/DungeonGraph.swift` | Framework | ADT: `DungeonNode`, `DungeonEdge`, `DungeonGraph` |
| `Level/Structure/RoomPopulatorStrategy.swift` | Framework | Protocol: strategy for spawning gameplay entities |
| `Level/Structure/RoomSpecification.swift` | Framework | Pure-data room description with `RoomPopulatorStrategy` |
| `Level/Orchestration/LevelOrchestrator.swift` | Framework | Service: level load, room transition, cleanup |
| `Level/Layout/LinearDungeonLayout.swift` | Game | Concrete layout: horizontal room chain |
| `Level/Interior/BoundsRoomInterior.swift` | Game | Concrete interior: perimeter walls + obstacles |
| `ECS/Components/Room/RoomMemberComponent.swift` | Framework | Tags every entity that belongs to a specific room |

---

## The Dungeon Graph

The dungeon topology is an explicit directed graph. Nodes are rooms, and edges are doorway connections.

### Why an Explicit Graph?
Instead of scattering connections across ECS `RoomComponent`s, an explicit `DungeonGraph` provides a single authoritative topology. ECS metadata is derived from the graph at build time. This allows algorithms like minimap rendering or AI pathfinding to query the map structure without touching the ECS World.

### Invariants
1. **Connectivity**: Every `edge.fromNodeID` and `edge.toNodeID` must exist in the graph's node set.
2. **Start Node**: A valid level must define a `startNodeID`.

---

## Generation Strategies

### `DungeonLayoutStrategy`
Responsible for the "Big Picture." It decides how many rooms exist, where they are in world space, and which ones are connected by corridors. 
- **LinearDungeonLayout**: A simple horizontal chain of rooms separated by corridors of a fixed length.

### `RoomInteriorStrategy`
Responsible for the "Details." It receives a `RoomSpecification` and populates the ECS World with the structural geometry (walls, floors).
- **BoundsRoomInterior**: Uses a wall-splitting algorithm to emit perimeter segments while leaving gaps for doorways.

### `RoomPopulatorStrategy`
The **"Seam"** between the generation framework and specific game content. 
1. **Framework**: Defines the `populate` contract.
2. **Game Layer**: Implements logic for spawning specific enemies or loot (e.g., `EnemyRoomPopulator`).
3. **Execution**: `LevelOrchestrator` invokes the populator after the geometry is built.


