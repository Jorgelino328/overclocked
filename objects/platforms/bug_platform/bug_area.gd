extends Area2D

@export var bug_limit = 10

signal limit_reached()

func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	if bodies.size() >= bug_limit:
		limit_reached.emit()
	
