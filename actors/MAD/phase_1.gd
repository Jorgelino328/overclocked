extends StaticBody2D

@onready var bug = preload("res://actors/crawling_bug/crawling_bug.tscn")
@onready var spawn1 = $Spawn1
@onready var spawn2 = $Spawn2

@export var bug_platform1 : StaticBody2D
@export var shoot_strength := 50

var limit_bug1 := false

func _ready() -> void:
	var bug_area1 = bug_platform1.get_node("BugArea")
	bug_area1.limit_reached.connect(_on_limit_reached)

func _on_spawn_1_timer_timeout() -> void:
	if not limit_bug1:
		var new_bug = bug.instantiate()
		spawn1.add_child(new_bug)
		var direction = global_position.direction_to(new_bug.global_position)
		var explosion_force = direction * shoot_strength
		new_bug.knockback = explosion_force
		await get_tree().create_timer(2).timeout
		new_bug.knockback = Vector2.ZERO
	
func _on_limit_reached():
	limit_bug1 = true
