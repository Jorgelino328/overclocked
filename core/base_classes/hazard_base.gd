## Script base para a classe Hazard, herdada por todos os obstaculos danosos do jogo
class_name Hazard extends Area2D

@export var hp := 5

@export var damage := 5

@export var knockback_strength := 50.0

var is_destroyed := false;

## WARNING: Lembre de adicionar super._process(delta) na classe filha caso for adicionar um novo _process
func _process(_delta):
	if hp <= 0:
		is_destroyed = true
		
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var direction = global_position.direction_to(body.global_position)
		var explosion_force = direction * knockback_strength
		body.knockback = explosion_force
		body.take_damage(damage)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.knockback = Vector2.ZERO
	
func despawn():
	queue_free()
	
