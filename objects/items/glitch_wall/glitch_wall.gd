extends Hazard

@onready var spawn_start = $Marker2D
@onready var animation = $AnimationPlayer
@onready var timer = $Timer
@onready var hurt_sfx = $HurtSFX
@onready var not_hurt_sfx = $NotHurtSFX
@onready var numbers = preload("res://objects/projectiles/numbers/numbers.tscn")
@export var start_amount = 20
@export var active = true


func _ready():
	hp = start_amount

func _process(_delta):
	super._process(_delta)
	if is_destroyed && !has_overlapping_areas():
		queue_free()

func take_damage(dmg):
	if active:
		animation.play("hurt")
		hurt_sfx.play()
		hp -= dmg
	else:
		not_hurt_sfx.play()

func spawn_numbers():
	var r_spawn = randi_range(-40,40)
	var new_number = numbers.instantiate()
	new_number.active = active
	spawn_start.add_child(new_number)
	new_number.position.x = r_spawn

func _on_timer_timeout() -> void:
	for i in range(hp):
		if !is_destroyed:
			spawn_numbers()
	timer.start()

func _on_area_exited(area: Area2D) -> void:
	if area.has_method("free_number"):
		area.free_number()
