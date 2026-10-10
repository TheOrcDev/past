extends Node
## The whole game's state in one versioned dictionary (docs/technical-plan.md
## §5.7). Flags and the inventory so far; saving and loading arrive in plan 004
## slice 6.

const SAVE_VERSION := 1

var flags := {}
## Carried item ids, in the order found (see the Inventory autoload).
var inventory: Array[StringName] = []


func set_flag(flag: StringName, value: Variant = true) -> void:
	flags[flag] = value


func get_flag(flag: StringName, default: Variant = false) -> Variant:
	return flags.get(flag, default)
