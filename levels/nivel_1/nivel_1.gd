extends Level

@onready var fonte = $Fonte

@export var proxima_fase = "res://levels/nivel_2/nivel_2.tscn"
@export var music = preload("res://assets/audio/music/lab.ogg")

var psu_dialogue_1 = "res://assets/dialogue/psu_dialogue_1.json"
var psu_dialogue_2 = "res://assets/dialogue/psu_dialogue_2.json"

func _ready() -> void:
	fonte.found_psu.connect(play_scene.bind(psu_dialogue_1))

func _process(_delta) -> void:
	super._process(_delta)
	if(!has_node("DialogueUI")):
		unfreeze_chars()
	else:
		freeze_chars()

func level_finish():
	emit_signal("level_cleared", proxima_fase)

func _on_goal_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.has_psu:
			level_finish()
		else:
			play_scene(psu_dialogue_2)

func _on_death_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hp = 0
