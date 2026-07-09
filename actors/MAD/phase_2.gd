class_name RangedEnemy extends Enemy

@export var is_active := false
@export var shoot_interval := 2.0
@export var projectile_scene: PackedScene
@onready var head = $Head 
@onready var muzzle = $Head/Muzzle

var shoot_timer := 0.0
var player_ref: Player

func _ready() -> void:
	hp = 15
	speed = 80.0
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_ref = players[0]

func _physics_process(delta: float) -> void:
	if not is_active or is_dead:
		velocity = Vector2.ZERO
		return
		
	# Se o jogador foi encontrado, persegue e atira
	if player_ref:
		_chase_player()
		_aim_head()
		_handle_shooting(delta)
		
	move_and_slide()

func _chase_player() -> void:
	# Calcula a direção apontando para o jogador e aplica a velocidade
	var direction = global_position.direction_to(player_ref.global_position)
	velocity = direction * speed

func _handle_shooting(delta: float) -> void:
	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot_timer = 0.0
		_shoot()

func _aim_head() -> void:
	# Mira a cabeça na direção do jogador
	head.look_at(player_ref.global_position)

func _shoot() -> void:
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = muzzle.global_position
	projectile.rotation = head.global_rotation
