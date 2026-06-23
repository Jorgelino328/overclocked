extends StaticBody2D

@onready var animator = $CoolerAnimator

@export var knockback_strength := 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("cooler")
	
	


func _on_wind_area_body_entered(body: Node2D) -> void:
	if body is Player:
		var direction = global_position.direction_to(body.global_position)
		var explosion_force = direction * knockback_strength
		body.knockback = explosion_force
		



func _on_wind_area_body_exited(body: Node2D) -> void:
	if body is Player:
		body.knockback = Vector2.ZERO
