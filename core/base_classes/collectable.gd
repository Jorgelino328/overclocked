extends Area2D
class_name Collectable

@onready var animation = $AnimationPlayer
@export var heal_amount := 0

# Define sinal para ser usado pelas classes filhas
signal item_found()

func _ready() -> void:
	animation.play("Idle")

func _on_body_entered(body: Node2D) -> void:
	# Checa se o jogador já tem o item
	if body is Player and not is_already_collected(body):
		body.heal(heal_amount) # "Cura" 0 de hp só pra tocar o mesmo sfx
		mark_as_collected(body)
		item_found.emit()
		queue_free()

# Essas funções devem ser sobrescritas pelas classes filhas
func is_already_collected(body: Player) -> bool:
	return false # Default: Assume que não foi coletado

func mark_as_collected(body: Player) -> void:
	pass # Default: Fazer nada
