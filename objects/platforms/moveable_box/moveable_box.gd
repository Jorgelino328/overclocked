extends RigidBody2D

var on_left_box = false
var on_right_box = false
var player : Player

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("interact"):
		if on_left_box:
			player.is_pushing = true
			linear_velocity.x = player.current_speed
		elif on_right_box:
			player.is_pushing = true
			linear_velocity.x = -player.current_speed
	else:
		if player:
			player.is_pushing = false
		linear_velocity.x = 0

func _on_move_box_left_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
	on_left_box = true

func _on_move_box_right_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
	on_right_box = true


func _on_move_box_left_body_exited(body: Node2D) -> void:
	on_left_box = false
	player = null
	body.is_pushing = false


func _on_move_box_right_body_exited(body: Node2D) -> void:
	on_right_box = false
	player = null
	body.is_pushing = false
