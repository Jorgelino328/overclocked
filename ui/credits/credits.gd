extends Control

@export var scroll_speed: float = 60.0
@export var credits_file_path: String = "res://assets/credits.txt"
@export var music = preload("res://assets/audio/music/menu_music.ogg")

@onready var message_box: Control = $MessageBox
@onready var credits_label: Label = $MessageBox/Credits


signal menu()

func setup_connections(controller: Node) -> void:
	menu.connect(controller._on_menu) 

func _ready() -> void:
	load_credits_from_file()
	credits_label.position.y = message_box.size.y

func _process(delta: float) -> void:
	credits_label.position.y -= scroll_speed * delta
	
	if credits_label.position.y < -credits_label.size.y:
		finish_credits()

func load_credits_from_file() -> void:
	if FileAccess.file_exists(credits_file_path):
		var file = FileAccess.open(credits_file_path, FileAccess.READ)
		credits_label.text = file.get_as_text()
		file.close()
	else:
		credits_label.text = "Erro: credits.txt não encontrado em " + credits_file_path

func finish_credits() -> void:
	menu.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		finish_credits()
