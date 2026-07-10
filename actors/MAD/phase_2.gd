class_name RangedEnemy extends Enemy

@export var is_active := false
@export var shoot_interval := 2.0
@export var projectile_scene: PackedScene
@onready var head = $Head 
@onready var arms = $SideArms
@onready var muzzle = $Head/Muzzle
@onready var muzzle2 = $SideArms/Muzzle2
@onready var hurt_sfx = $HurtSFX
@onready var animation = $AnimationPlayer
@export var min_turn := -PI/4
@export var max_turn := PI/4
@export var player_ref : Player

var shoot_timer := 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

signal boss_defeated()

func _ready() -> void:
	hp = 25
	speed = 80.0
	knockback_strength = 250.0
	
	if player_ref == null:
		player_ref = get_parent().player

func _physics_process(delta: float) -> void:
	
	if is_dead && animation.current_animation != "destroy":
		animation.play("destroy")
		
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if not is_active or is_dead:
		velocity.x = 0
		move_and_slide()
		return
		
	# Se o jogador foi encontrado, persegue e atira
	if player_ref:
		_chase_player()
		_aim_head_and_arms()
		_handle_shooting(delta)
	
	if velocity.x != 0:
		animation.play("walking")
	else:
		animation.play("idle")
	
	move_and_slide()

func _chase_player() -> void:
	# Mantém a correção anterior para focar apenas no eixo X
	var direction_x = sign(player_ref.global_position.x - global_position.x)
	velocity.x = direction_x * speed

func _handle_shooting(delta: float) -> void:
	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot_timer = 0.0
		_shoot()

func _aim_head_and_arms() -> void:
	# Mira a cabeça na direção do jogador
	head.look_at(player_ref.global_position)
	arms.look_at(player_ref.global_position)
	
	# Limita movimento da cabeça
	head.rotation = clamp(head.rotation, min_turn, max_turn)
	arms.rotation = clamp(head.rotation, min_turn, max_turn)

func _shoot() -> void:
	var projectile1 = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile1)
	projectile1.global_position = muzzle.global_position
	projectile1.rotation = head.global_rotation
	
	var projectile2 = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile2)
	projectile2.global_position = muzzle2.global_position
	projectile2.rotation = arms.global_rotation

func take_damage(dmg):
	hurt_sfx.play()
	animation.play("hurt")
	hp -= dmg


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "destroy":
		boss_defeated.emit()
		queue_free()
