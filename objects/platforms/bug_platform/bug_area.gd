extends Area2D

@export var bug_limit = 3

@onready var platform = get_parent()

var signal_sent = false

signal limit_reached()

func _physics_process(_delta) -> void:
	var bodies = get_overlapping_bodies()
	var alive_bugs = []
	
	for body in bodies:
		if body.has_meta("needs_reparent"):
			_process_reparenting(body)
		if body.name == "CrawlingBug" and not body.is_doomed:
			alive_bugs.append(body)
			
	_check_bug_limit(alive_bugs)

func _process_reparenting(body: Node2D) -> void:
	body.remove_meta("needs_reparent")
	body.reparent(platform)

func _check_bug_limit(alive_bugs: Array) -> void:
	if alive_bugs.size() < bug_limit:
		return
	if not signal_sent:
		limit_reached.emit()
		signal_sent = true
	else:
		var excess_amount = alive_bugs.size() - bug_limit
		alive_bugs.shuffle()
		for i in excess_amount:
			alive_bugs[i].is_doomed = true
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "CrawlingBug" and body not in get_children():
		body.set_meta("needs_reparent", self)
