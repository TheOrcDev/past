class_name Closeup
extends Node2D
## A close-up view (plan 007): a full-screen image of something seen closer,
## with its own hotspots, opened from a room by `Closeups`. Like a room, its
## script answers verbs as `<verb>_<hotspot id>()`. There is no walking here.
## Children: Background (Sprite2D, 1920x1080, not centred) and Hotspots.

@export var closeup_id: StringName

@onready var hotspots: Node2D = $Hotspots


## The topmost active hotspot under `point` (screen pixels), or null.
func hotspot_at(point: Vector2) -> Hotspot:
	var best: Hotspot = null
	for node in hotspots.get_children():
		var hotspot := node as Hotspot
		if hotspot and hotspot.is_active() and hotspot.contains_point(point):
			if best == null or hotspot.pick_priority > best.pick_priority:
				best = hotspot
	return best


## The close-up a node belongs to, or null.
static func of(node: Node) -> Closeup:
	var current := node
	while current:
		if current is Closeup:
			return current
		current = current.get_parent()
	return null
