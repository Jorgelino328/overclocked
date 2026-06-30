extends Resource
class_name SettingsData

@export var fullscreen: bool = false
@export var borderless: bool = false
@export var vsync: bool = false

@export var volume_master: float = 0.0
@export var volume_music: float = 0.0
@export var volume_sfx: float = 0.0

func save_data(f_screen: bool, b_less: bool, v_sync: bool, v_master: float, v_music: float, v_s_f_x: float) -> void:
	fullscreen = f_screen
	borderless = b_less
	vsync = v_sync
	volume_master = v_master
	volume_music = v_music
	volume_sfx = v_s_f_x
