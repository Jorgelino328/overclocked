extends StaticBody2D

@onready var bug = preload("res://actors/crawling_bug/crawling_bug.tscn")
@onready var energyBall = preload("res://objects/projectiles/energy_ball/energy_ball.tscn")
@onready var spawn1 = $Spawn1
@onready var spawn2 = $Spawn2
@onready var timer1 = $Spawn1Timer
@onready var timer2 = $Spawn2Timer
@onready var gun1 = $HitBox1
@onready var gun2 = $HitBox2
@onready var animation = $AnimationPlayer
@onready var not_hurt_sfx = $NotHurtSFX
@onready var boss_controller = get_parent()
@onready var shoot_sfx := [$ShootSFX1,$ShootSFX1,$ShootSFX1]

@export var bug_platforms : Array[StaticBody2D]
@export var shoot_strength := 50
@export var guns_destroyed = 0

var bug_limit := 6
var bug_amnt := 0 
var bug_counter := 0
var is_active := false
var timers_started := false

signal start_phase_2()

func _ready() -> void:
	gun1.gun_destroyed.connect(progress_destruction)
	gun2.gun_destroyed.connect(progress_destruction)
	for platform in bug_platforms:
		var bug_area = platform.get_node("BugArea")
		bug_area.limit_reached.connect(_on_limit_reached)

func _process(_delta) -> void:
	is_active = boss_controller.is_active
	
	if guns_destroyed >= 2 and animation.current_animation != "destroy":
		animation.play("destroy")
	elif animation.current_animation != "destroy":
		animation.play("idle")
		
	
	if is_active and not timers_started:
		timer1.start()
		timer2.start()
		timers_started = true
		
func _on_spawn_1_timer_timeout() -> void:
	if bug_amnt < bug_limit:
		var new_bug = bug.instantiate()
		spawn1.add_child(new_bug)
		var direction = global_position.direction_to(new_bug.global_position)
		var explosion_force = direction * shoot_strength
		new_bug.knockback = explosion_force
		bug_counter += 1
	var r_sfx = shoot_sfx.pick_random()
	r_sfx.play()
	timer1.start()

func _on_limit_reached():
	bug_amnt += 1

func _on_spawn_2_timer_timeout() -> void:
	var new_ball = energyBall.instantiate()
	spawn2.add_child(new_ball)
	timer2.start()

func take_damage(_dmg):
	not_hurt_sfx.play()
	
func progress_destruction():
	guns_destroyed += 1
	print(guns_destroyed)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "destroy":
		start_phase_2.emit()
		queue_free()
