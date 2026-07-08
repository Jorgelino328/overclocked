extends StaticBody2D

@onready var bug = preload("res://actors/crawling_bug/crawling_bug.tscn")
@onready var spawn1 = $Spawn1
@onready var spawn2 = $Spawn2

@export var bug_platform : Array[StaticBody2D]
@export var shoot_strength := 50

var bug_limit := 0

func _ready() -> void:
	for platform in bug_platform:
		var bug_area = platform.get_node("BugArea")
		bug_area.limit_reached.connect(_on_limit_reached)

func _on_spawn_1_timer_timeout() -> void:
	if bug_limit < 6:
		var new_bug = bug.instantiate()
		spawn1.add_child(new_bug)
		var direction = global_position.direction_to(new_bug.global_position)
		var explosion_force = direction * shoot_strength
		new_bug.knockback = explosion_force
		await get_tree().create_timer(2).timeout
		if is_instance_valid(new_bug):
			new_bug.knockback = Vector2.ZERO
	
func _on_limit_reached():
	bug_limit += 1
