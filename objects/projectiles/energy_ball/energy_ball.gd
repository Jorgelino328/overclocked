extends Node2D
@onready var animation = $AnimationPlayer
@onready var collider = $CollisionShape2D

@export var speed: float = 600.0
@export var damage: int = 5

func _ready() -> void:
	animation.play("shoot")
	animation.queue("traveling")

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_or_area_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	speed = 0
	animation.play("hit")
	collider.set_deferred("disabled", true)
	
	await animation.animation_finished
	queue_free()
