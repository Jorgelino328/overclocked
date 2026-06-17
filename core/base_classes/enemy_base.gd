## Script base para a classe Enemy, herdada por todos os inimigos do jogo
class_name Enemy extends CharacterBody2D

## Todos os inimigos tem HP, o valor padrão é 5.
## INFO: Modifique no script do inimgo para valores diferentes.
@export var hp := 5

## Todos os inimigos possuem uma velocidade base. O valor padrão é 20;
## INFO: Modifique no script do inimgo para valores diferentes.
@export var speed := 20.0

## Todos os inimigos dão dano ao jogador ao tocar nele, o valor padrão é 5.
## INFO: Modifique no script do inimgo para ajustar o dano.
@export var damage := 5

## Todos os inimigos dão dano ao jogador ao tocar nele, o valor padrão é 50.0.
## INFO: Modifique no script do inimgo para ajustar o knockback.
@export var knockback_strength := 50.0

## Todos os inimigos possuem um booleano "is_dead". Que inicia como false e vira true ao morrer;
## INFO: Útil como trigger para animações ou outros eventos relacionados à morte de um inimigo.
var is_dead := false;

## WARNING: Lembre de adicionar super._process(delta) na classe filha caso for adicionar um novo _process
func _process(delta):
	if hp <= 0:
		is_dead = true

## Todos os inimigos possuem uma hitbox para detectar o jogador.
## WARNING: Você ainda precisa criar a Area2D na classe filha, 
## nomeá-la "HitBox", e conectar p sinal "body_entered" .
func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Player:
		var direction = global_position.direction_to(body.global_position)
		var explosion_force = direction * knockback_strength
		body.knockback = explosion_force
		body.take_damage(damage)

func _on_hit_box_body_exited(body: Node2D) -> void:
	if body is Player:
		body.knockback = Vector2.ZERO
	
func despawn():
	queue_free()
	
