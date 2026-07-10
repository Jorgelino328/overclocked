extends Control
var id = 2

@onready var opt = $Options
@onready var Video = $Video
@onready var Audio = $Audio

@onready var v_master = $Audio/HBoxContainer/Slider/Master
@onready var v_music = $Audio/HBoxContainer/Slider/Music
@onready var v_sfx = $"Audio/HBoxContainer/Slider/Sound FX"

@onready var fscreen = $Video/HBoxContainer/Checks/FullScreen
@onready var borderless = $Video/HBoxContainer/Checks/Bordeless
@onready var vsync = $Video/HBoxContainer/Checks/VSync

@onready var hover_sfx = $HoverSfx

@export var music = preload("res://assets/audio/music/menu_music.ogg")

var settingsData = SettingsData.new()
var save_file_path = "user://save/"
var save_file_name = "SettingsSave.tres"

signal back_menu()
signal quit()

func setup_connections(controller: Node):
	back_menu.connect(controller._on_menu)
	quit.connect(controller._on_quit)

# Config
func _ready():
	verify_save_directory(save_file_path)
	
	if ResourceLoader.exists(save_file_path + save_file_name):
		settingsData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	
	v_master.set_value_no_signal(db_to_linear(settingsData.volume_master))
	v_music.set_value_no_signal(db_to_linear(settingsData.volume_music))
	v_sfx.set_value_no_signal(db_to_linear(settingsData.volume_sfx))
	
	fscreen.set_pressed_no_signal(settingsData.fullscreen)
	borderless.set_pressed_no_signal(settingsData.borderless)
	vsync.set_pressed_no_signal(settingsData.vsync)
	
	init_volume()
	
	_on_full_screen_toggled(settingsData.fullscreen)
	_on_bordeless_toggled(settingsData.borderless)
	_on_v_sync_toggled(settingsData.vsync)

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		toggle()
		
func toggle():
	visible = !visible
	get_tree().paused = visible

func show_and_hide(first,second):
	first.show()
	second.hide()
		
# Options Menu
func _on_exit_pressed():
	get_tree().paused = false 
	emit_signal("quit")

func _on_video_pressed():
	show_and_hide(Video,opt)

func _on_audio_pressed():
	show_and_hide(Audio,opt)
	
func _on_back_from_options_pressed():
	emit_signal("back_menu")

# Video Menu
	
func _on_full_screen_toggled(button_pressed):
	if(button_pressed):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	settingsData.fullscreen = button_pressed
	
func _on_bordeless_toggled(button_pressed):
	if(button_pressed):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	settingsData.borderless = button_pressed
	
func _on_v_sync_toggled(button_pressed):
	if(button_pressed):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	settingsData.vsync = button_pressed

func _on_back_from_video_pressed():
	settingsData.save_data(fscreen.button_pressed,borderless.button_pressed,vsync.button_pressed,linear_to_db(v_master.value),linear_to_db(v_music.value),linear_to_db(v_sfx.value))	
	ResourceSaver.save(settingsData, save_file_path + save_file_name)
	show_and_hide(opt,Video)

# Audio Menu
func volume(bus_index,value):
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))

func init_volume():
	volume(0,v_master.value)
	volume(1,v_music.value)
	volume(2,v_sfx.value)

func _on_master_value_changed(value):
	volume(0,value)
	
func _on_music_value_changed(value):
	volume(1,value)

func _on_sound_fx_value_changed(value):
	volume(2,value)

func _on_back_from_audio_pressed():
	settingsData.save_data(fscreen.button_pressed,borderless.button_pressed,vsync.button_pressed,linear_to_db(v_master.value),linear_to_db(v_music.value),linear_to_db(v_sfx.value))
	ResourceSaver.save(settingsData, save_file_path + save_file_name)
	show_and_hide(opt,Audio)
	
func _on_back_to_menu_pressed():
	get_tree().paused = false
	emit_signal("back_menu")
	
# Other
func _on_quit_game_pressed():
	get_tree().paused = false
	emit_signal("quit")


func _on_mouse_entered() -> void:
	hover_sfx.play()
