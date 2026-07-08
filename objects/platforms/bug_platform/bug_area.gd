extends Area2D

@export var bug_limit = 3
var signal_sent = false

signal limit_reached()


func _physics_process(_delta) -> void:
	var bodies = get_overlapping_bodies()
	var alive_bugs = []
	for body in bodies:
		if body is Enemy and body.hp > 0: 
			alive_bugs.append(body)
	if alive_bugs.size() >= bug_limit and not signal_sent:
		limit_reached.emit()
		signal_sent = true
	elif alive_bugs.size() > bug_limit:
		var excess_amount = alive_bugs.size() - bug_limit
		alive_bugs.shuffle()
		for i in excess_amount:
			var doomed_bug = alive_bugs[i]
			doomed_bug.take_damage(doomed_bug.hp)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and body not in get_children():
		body.call_deferred("reparent", self)
