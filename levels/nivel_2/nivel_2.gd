extends Level

@onready var hdd = $Hdd 

@export var proxima_fase = "res://ui/end_game/end_game.tscn"
@export var music = preload("res://assets/audio/music/ice.ogg")

var hdd_dialogue_1 = "res://assets/dialogue/hdd_dialogue_1.json"
var hdd_dialogue_2 = "res://assets/dialogue/hdd_dialogue_2.json"

func _ready() -> void:
	hdd.found_hdd.connect(play_scene.bind(hdd_dialogue_1))


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
		if body.has_hdd:
			level_finish()
		else:
			play_scene(hdd_dialogue_2)

func _on_death_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hp = 0
