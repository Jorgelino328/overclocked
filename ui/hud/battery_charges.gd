extends HBoxContainer

@onready var player = get_parent().get_parent().get_parent()
@onready var battery = $Battery


func _ready():
	player.battery_changed.connect(update_charge)
	if player.has_psu :
		battery.visible = true
		update_charge(player.energy)
	else:
		battery.visible = false

func update_charge(current_energy):
	if player.has_psu && !battery.visible:
		battery.visible = true
	var charge_amnt = 18*current_energy
	battery.texture.region = Rect2(charge_amnt, 0, 18, 8) 
