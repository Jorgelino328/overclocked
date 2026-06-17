extends Level

@onready var start_pos = $PontoDeInicio
@onready var level_path = "res://levels/testing/level_prototype.tscn"


func ganhei():
	emit_signal("next_level", level_path)


func _on_cooler_body_entered(body: Node2D) -> void:
	if body is Player:
		ganhei()
