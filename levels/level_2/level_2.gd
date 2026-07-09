extends Level

@onready var hdd = $Hdd 

@export var proxima_fase = "res://levels/level_3/level_3.tscn"
@export var music = preload("res://assets/audio/music/ice.ogg")

var wall_dialogue = "res://assets/dialogue/wall_dialogue.json"
var hdd_dialogue_1 = "res://assets/dialogue/hdd_dialogue_1.json"
var hdd_dialogue_2 = "res://assets/dialogue/hdd_dialogue_2.json"

func _ready() -> void:
	player.has_psu = true
	player.has_hdd = false
	player.has_ram = false
	player.has_cpus = false
	hdd.item_found.connect(play_scene.bind(hdd_dialogue_1))
	play_scene(wall_dialogue)

func _process(_delta) -> void:
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
		
func _on_player_morreu() -> void:
	emit_signal("game_over")
