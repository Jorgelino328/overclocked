extends Level

enum DialogueState 
{ 
	ARRIVAL, 
	BATTLE_START, 
	BATTLE_END, 
	FIND_RAM, 
	RAM_TIP,
	FIND_CPU, 
	LEVEL_CLEAR, 
	END
}

@onready var ram = $RamStick
@onready var cpu = $Cpu
@onready var mad = $Mad
@onready var fight_trigger = $FightTrigger

@export var proxima_fase = "res://ui/end_game/end_game.tscn"
@export var music = preload("res://assets/audio/music/lab.ogg")
@export var is_active = false

var tip_given = false
var curr_dialogue = DialogueState.ARRIVAL
var arrival_dialogue = "res://assets/dialogue/l3_arrival.json"
var find_ram_dialogue = "res://assets/dialogue/l3_find_ram.json"
var ram_tip_dialogue = "res://assets/dialogue/l3_ram_tip.json"
var find_cpu_dialogue = "res://assets/dialogue/l3_find_cpu.json"
var battle_start_dialogue = "res://assets/dialogue/l3_battle_start.json"
var battle_end_dialogue = "res://assets/dialogue/l3_battle_end.json"
var level_clear_dialogue = "res://assets/dialogue/l3_level_clear.json"
var phase_2_started = false

func _ready() -> void:
	ram.item_found.connect(play_scene.bind(find_ram_dialogue))
	cpu.item_found.connect(play_scene.bind(find_cpu_dialogue))
	
func _process(_delta) -> void:
	if mad.phase_2.is_active and not phase_2_started:
		player.anim_state = player.State.TRANSITION
		is_active = false
		phase_2_started = true
	
	if(!has_node("DialogueUI")):
		unfreeze_chars()
		match curr_dialogue:
			DialogueState.ARRIVAL:
				play_scene(arrival_dialogue)
				curr_dialogue = DialogueState.END
			DialogueState.FIND_RAM:
				play_scene(find_ram_dialogue)
				curr_dialogue = DialogueState.END
			DialogueState.RAM_TIP:
				play_scene(ram_tip_dialogue)
				curr_dialogue = DialogueState.END
			DialogueState.BATTLE_START:
				play_scene(battle_start_dialogue)
				is_active = true
				curr_dialogue = DialogueState.END
			DialogueState.BATTLE_END:
				play_scene(battle_end_dialogue)
				is_active = false
				curr_dialogue = DialogueState.END
			DialogueState.FIND_CPU:
				play_scene(find_cpu_dialogue)
				curr_dialogue = DialogueState.END
			DialogueState.LEVEL_CLEAR:
				play_scene(level_clear_dialogue)
				curr_dialogue = DialogueState.END
			DialogueState.END:
				pass
	else:
		freeze_chars()

func level_finish():
	emit_signal("level_cleared", proxima_fase)

#func _on_goal_body_entered(body: Node2D) -> void:
	#if body is Player:
		#if body.has_psu:
			#level_finish()
		#else:
			#play_scene(psu_dialogue_2)

func _on_death_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hp = 0
		
func _on_player_morreu() -> void:
	emit_signal("game_over")


func _on_fight_trigger_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.has_ram:
			curr_dialogue = DialogueState.BATTLE_START
			fight_trigger.queue_free()
		elif not tip_given:
			curr_dialogue = DialogueState.RAM_TIP
			tip_given = true
