extends Node2D
@onready var parent_level = get_parent()
@onready var phase_1 = $Phase1
@onready var phase_2 = $Phase2

@export var player : Player

var is_active = false

func _ready() -> void:
	phase_1.start_phase_2.connect(_on_start_phase_2)

func _process(_delta) -> void:
	is_active = parent_level.is_active

func _on_start_phase_2():
	phase_2.is_active = true
	
