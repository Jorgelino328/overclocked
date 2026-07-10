extends Node

@onready var current_scene := $MainMenu
@onready var bgm_player := $GlobalAudio/BackgroundMusic
@onready var sfx_player := $GlobalAudio/SFX

var current_track := preload("res://assets/audio/music/menu_music.ogg")
var select_sfx := preload("res://assets/audio/sfx/button_select.ogg")
var death_sfx := preload("res://assets/audio/sfx/death.ogg")
var music_tween: Tween


# Preload de Cenas de UI para transições mais rápidas
const MAIN_MENU = preload("res://ui/main_menu/main_menu.tscn")
const SETTINGS = preload("res://ui/settings/settings.tscn")
const LEVEL_CLEAR = preload("res://ui/level_clear/level_clear.tscn")
const GAME_OVER = preload("res://ui/game_over/game_over.tscn")
const CREDITS = preload("res://ui/credits/credits.tscn")

func _ready() -> void:
	bgm_player.stream = current_track
	connect_signals()
	load_and_apply_settings()

## Pede para a cena atual conectar seus sinais ao controlador.
func connect_signals():
	if current_scene.has_method("setup_connections"):
		current_scene.setup_connections(self)
	else:
		push_warning("Erro: Cena não tem setup de conexões!")
	
## Troca a cena atual por uma nova cena.
##
## Adiciona a nova cena como filha, remove a cena antiga
## e atualiza a variável current_scene
func change_scene(next_scene):
	add_child(next_scene)
	current_scene.queue_free() 
	current_scene = next_scene
	if "music" in current_scene:
		play_music(current_scene.music)
	else:
		stop_music()
	connect_signals()

func play_music(music: AudioStream) -> void:
	if bgm_player.stream == music and bgm_player.playing:
		return
		
	if music_tween:
		music_tween.kill()
		
	if bgm_player.playing:
		music_tween = create_tween()
		music_tween.tween_property(bgm_player, "volume_db", -80.0, 0.5)
		await music_tween.finished
		
	bgm_player.stream = music
	bgm_player.volume_db = 0.0 
	bgm_player.play()


func stop_music() -> void:
	if music_tween:
		music_tween.kill()
		
	if bgm_player.playing:
		music_tween = create_tween()
		music_tween.tween_property(bgm_player, "volume_db", -80.0, 0.5)
		await music_tween.finished
		bgm_player.stop()
		
## Toca SFX global.
func play_sfx(sfx):
	sfx_player.stream = sfx
	sfx_player.play()
	
	await sfx_player.finished
	
## --- Carrega cenas de UI ---

func _on_menu():
	await play_sfx(select_sfx)
	change_scene(MAIN_MENU.instantiate())

func _on_settings():
	await play_sfx(select_sfx)
	change_scene(SETTINGS.instantiate())

func _on_credits():
	await play_sfx(select_sfx)
	change_scene(CREDITS.instantiate())

func _on_level_clear(proxima_fase_path: String):
	
	var next_scene = LEVEL_CLEAR.instantiate()
	next_scene.level_path = proxima_fase_path 
	
	change_scene(next_scene)
	
func _on_game_over():
	await play_sfx(death_sfx)
	var next_scene = GAME_OVER.instantiate()
	next_scene.level_path = current_scene.scene_file_path
	change_scene(next_scene)
	
func _on_quit():
	await play_sfx(select_sfx)
	get_tree().quit()

## -------------------

## Carrega próximo nível
func _on_next_level(level_path : String):
	if level_path != "":
		await play_sfx(select_sfx)
		var next_level = load(level_path)
		change_scene(next_level.instantiate())

# TODO: Implement load checkpoint logic
func _on_continue_game():
	pass

## Espera 3 segundos antes de tocar a música do menu
func _on_timer_timeout() -> void:
	if current_track != null:
		bgm_player.play()


func load_and_apply_settings():
	var save_file_path = "user://save/"
	var save_file_name = "SettingsSave.tres"
	
	if ResourceLoader.exists(save_file_path + save_file_name):
		var data = ResourceLoader.load(save_file_path + save_file_name)
		
		# 1. Apply Volumes
		AudioServer.set_bus_volume_db(0, data.volume_master)
		AudioServer.set_bus_volume_db(1, data.volume_music)
		AudioServer.set_bus_volume_db(2, data.volume_sfx)
		
		# 2. Apply Window Settings
		# Fullscreen / Windowed
		if data.fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
		# Borderless
		if data.borderless:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		
		# VSync
		if data.vsync:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
