extends Area2D

@onready var animation = $AnimationPlayer
@onready var collider = $CollisionShape2D
@onready var shoot_sfx = [$ShootSFX1, $ShootSFX2]

var direction = Vector2.RIGHT
@export var speed: float = 600.0
@export var damage: int = 5

func _ready() -> void:
	var r_sfx = shoot_sfx.pick_random()
	r_sfx.play()

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if body is Player:
		body.take_damage(damage)
	
	speed = 0
	animation.play("hit")
	collider.set_deferred("disabled", true)
	
	await animation.animation_finished
	queue_free()
