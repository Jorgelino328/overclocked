## Define o script do jogador como uma classe do tipo "Player", para facilitar identificação
class_name Player extends CharacterBody2D

signal morreu

# Variáveis costumizáveis no Inspector do Godot 
@export var speed_slow := 50.0
@export var speed_walk := 300.0
@export var speed_run := 600.0
@export var jump_velocity := -350.0
@export var hp := 10
@export var max_hp := 10
@export var i_frames: float = 1.0 # Mudado para float para a divisão ser perfeita
@export var i_frame_dur: float = 0.2 # Tipagem explícita adicionada
@export var energy: int = 4
@export var shoot_cost: int = 1

# Variáveis definidas ao inicializar Node
@onready var current_speed := speed_walk
@onready var animation_player = $RobonildoAnimator
@onready var sprite = $RobonildoSprite
@onready var hurt_sfx = $SFX/HurtSFX
@onready var jump_sfx = $SFX/JumpSFX
@onready var rocket_sfx = $SFX/RocketSFX
@onready var heal_sfx = $SFX/HealSFX
@onready var gun_arm = $GunArm
@onready var gun_timer = $GunTimer
@onready var battery_timer = $BatteryTimer
@onready var muzzle = $GunArm/Muzzle


# Define estados possíveis do personagem
enum State { IDLE, WALKING, RUNNING, JUMPING, LOOKING, PUSHING, DYING}

# Pega valor de gravidade definida nas configurações do projeto.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Inicia o jogo no estado Idle
var anim_state := State.IDLE

var time_walking := 0.0
var time_running := 0.0
var time_idle := 0.0
var time_pushing := 0.0
var just_jumped := false
var sideways := false
var dead_anim := false
var knockback = Vector2.ZERO
var is_invincible = false
var is_pushing = false

@export var has_psu = false
@export var has_hdd = false

var h_updated = false

var ray_scene = load("res://objects/projectiles/ray/ray.tscn")

signal health_changed(new_hp, max_hp)
signal battery_changed(charge)


func _ready():
	gun_arm.visible = false
	gun_timer.wait_time = 0.5

func _physics_process(delta):
	# Adiciona gravidade caso esteja fora do chão.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Se a HP do jogador chega a 0, toca a animação de morte
	if hp <= 0 and anim_state != State.DYING:
		anim_state = State.DYING
		_gerenciar_sequencia_morte()
	
	if has_hdd and not h_updated:
		max_hp *= 3 
		hp = max_hp
		emit_signal("health_changed", hp, max_hp)
		h_updated = true
	# Pega a direção do input
	var direction := Input.get_axis("walk_left", "walk_right")
	# Lógica da arma visível (rastrear mouse, virar corpo e inverter ombro)
	if gun_arm.visible and anim_state != State.DYING:
		var mouse_pos = get_global_mouse_position()
		gun_arm.look_at(mouse_pos)
		
		var aiming_left = mouse_pos.x < global_position.x
		sprite.flip_h = aiming_left
		sideways = true
		
		# Pega a distância base do braço (offset X)
		var arm_offset_x = abs(gun_arm.position.x)
		
		# Inverte a posição do braço para simular a troca de ombro
		if aiming_left:
			gun_arm.position.x = -arm_offset_x
		else:
			gun_arm.position.x = arm_offset_x
			
		# Vira o sprite da arma de cabeça para baixo caso esteja apontando pra trás
		gun_arm.flip_v = aiming_left

	# LÓGICA DE TIRO (Separada do movimento para permitir atirar andando)
	if Input.is_action_just_pressed("shoot") and has_psu and energy >= shoot_cost and anim_state != State.DYING:
		shoot_logic()

	# Define o estado atual de movimento
	if anim_state != State.DYING:
		
		# Se está no ar 
		if not is_on_floor():
			anim_state = State.JUMPING
		
		elif is_pushing:
			anim_state = State.PUSHING
		# Se acabou de pular
		elif Input.is_action_just_pressed("jump"):
			just_jumped = true
			anim_state = State.JUMPING
			velocity.y = jump_velocity
		
		# Se está olhando pra cima ou pra baixo
		elif Input.is_action_pressed("look_up") or Input.is_action_pressed("look_down"):
			if not Input.is_action_pressed("walk_left") and not Input.is_action_pressed("walk_right"): 
				anim_state = State.LOOKING
		
		# Se está se movendo no chão
		elif direction:
			sideways = true
			anim_state = State.WALKING if anim_state != State.RUNNING else State.RUNNING
			
		# Se está parado no chão
		elif anim_state != State.LOOKING:
			anim_state = State.IDLE
			
	# Aciona as animações PRIMEIRO, pois elas alteram a variável de velocidade. 
	animation_handler(direction, delta)
	
	# Se o personagem estiver vivo, aplica o movimento
	if anim_state != State.DYING:
		# Aplica a velocidade x (Sem travar se estiver atirando!)
		if direction:
			velocity.x = direction * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
		
		# Aplica o Knockback, se houver
		velocity += knockback
	else:
		# Garante que a velocidade seja zerada ao morrer
		velocity.x = 0.0
		
	# Função de movimento padrão do Godot
	move_and_slide()

func animation_handler(direction, delta):
	# Vira o sprite caso esteja indo pra esquerda E a arma não esteja forçando a direção
	if direction != 0 and anim_state != State.DYING and not gun_arm.visible:
		sprite.flip_h = (direction < 0)
		if is_pushing and (direction < 0):
			sprite.position.x = 33
		elif is_pushing and (direction > 0):
			sprite.position.x = -33
		else:
			sprite.position.x = 0
			
	
	# Para o loop de foguete ao parar de correr
	if time_running <= 0:
		rocket_sfx.stop() 
	
	# Define animação baseado no estado
	match anim_state:
		State.IDLE:
			# Se a arma está de fora enquanto parado, FORÇA a ficar de lado
			if gun_arm.visible:
				if animation_player.current_animation != "run_stop" and animation_player.current_animation != "RESET_side":
					animation_player.play("RESET_side")
				# Reseta o tempo para que ele não tente virar para a frente
				time_idle = 0.0 
			else:
				# Quando acaba de parar (Frame 0).
				if time_idle == 0.0:
					if sideways and time_running == 0.0:
						animation_player.play("RESET_side") # Fica congelado virado de lado.
					elif sideways:
						animation_player.play("run_stop") # Para de correr e permanece de lado.
					elif !sideways:
						animation_player.play("RESET") # Fica congelado virado de frente.
	
				# Após 1 segundo parado
				if time_idle < 1.0 and (time_idle + delta) >= 1.0:
					# Se estiver de lado, se vira e toca animação idle.
					if sideways:
						animation_player.play("turn_front")
						animation_player.queue("idle") 
						sideways = false # Reseta o estado para os próximos movimentos.
					
					# Se estiver de frente, toca animação idle imediatamente.
					else:
						animation_player.play("idle")
						
				# Só avança o timer de ficar parado se a arma estiver guardada
				time_idle += delta
				
			# Atualiza os outros timers
			time_walking = 0.0
			time_running = 0.0
			time_pushing = 0.0
			
		State.WALKING:
			# Se vira (caso já não esteja de lado) e começa a andar .
			if time_walking == 0.0:
				if !sideways: 
					animation_player.play("turn_side")
					animation_player.queue("walk")
				else:
					animation_player.play("walk")
					
			# Acelera quando estiver andando, mas para enquanto a animação de início estiver tocando.
			if animation_player.current_animation == "walk":
				current_speed = speed_walk
			
			# Atualiza os timers.
			time_walking += delta
			time_running = 0.0
			time_idle = 0.0
			time_pushing = 0.0
			
			# Após 2 segundos andando, começa a correr.
			if time_walking >= 2.0:
				anim_state = State.RUNNING
				
		State.RUNNING:
			# Se vira e começa a correr.
			if time_walking > 0.0 and time_running == 0.0:
				animation_player.play("run_start")
				animation_player.queue("run")
				rocket_sfx.play()
			
			# Acelera quando estiver correndo.
			if animation_player.current_animation == "run":
				current_speed = speed_run
			
			# Atualiza os timers.
			time_walking = 0.0
			time_running += delta 
			time_idle = 0.0
			time_pushing = 0.0
			
		State.JUMPING:
			# Se vira e começa a pular.
			if just_jumped:
				jump_sfx.play()
				if sideways:
					animation_player.play("jump_side_start")
					animation_player.queue("jump_side")
				else:
					animation_player.play("jump_front_start")
					animation_player.queue("jump_front")
				just_jumped = false
			
			# Se caindo (y positivo), tocar animação de aterrissagem.
			elif velocity.y >= 0.0:
				if sideways:
					animation_player.play("jump_side_land")
				else:
					animation_player.play("jump_front_land")
				
			time_walking = 0.0
			time_running = 0.0
			time_idle = 0.0
			time_pushing = 0.0
			
		State.LOOKING:
			# Toca a animação apropriada dependendo da orientação (de lado/frente).
			if Input.is_action_pressed("look_up"):
				if sideways:
					animation_player.play("look_side_up")
				else:
					animation_player.play("look_front_up")
			elif Input.is_action_pressed("look_down"):
				if sideways:
					animation_player.play("look_side_down")
				else:
					animation_player.play("look_front_down")
			else:
				anim_state = State.IDLE
				
			time_walking = 0.0
			time_running = 0.0
			time_idle = 0.0
			time_pushing = 0.0
		
		State.PUSHING:
			# Se vira (caso já não esteja de lado) e começa a empurrar .
			if time_pushing == 0.0:
				if !sideways: 
					animation_player.play("turn_side")
					animation_player.queue("push_start")
					animation_player.queue("push")
					rocket_sfx.play()
				else:
					animation_player.play("push_start")
					animation_player.queue("push")
					rocket_sfx.play()
					
			# Anda mais devagar quando está empurrando
			if animation_player.current_animation == "push":
				current_speed = speed_slow
			else:
				current_speed = 0
				
			time_walking = 0.0
			time_running = 0.0
			time_idle = 0.0
			time_pushing += delta 
				
		
		State.DYING:
			# Toca animação de morte correta para a situação
			if !dead_anim:
				if sideways and time_running > 0.0:
					animation_player.play("death_run")
				elif sideways and time_walking > 0.0:
					animation_player.play("death_walk")
				elif sideways:
					animation_player.play("death_side")
				else:
					animation_player.play("death_front")
				dead_anim = true # Evita que animação toque novamente

func heal(heal_amnt):
	heal_sfx.play()
	hp = clamp(hp + heal_amnt, 0, max_hp)
	emit_signal("health_changed", hp, max_hp)

func take_damage(dmg):
	if is_invincible:
		return
	
	hurt_sfx.play()
	hp -= dmg
	is_invincible = true
	emit_signal("health_changed", hp, max_hp)
	
	var tween_alpha = create_tween()
	var flash_count: int = int(i_frames / i_frame_dur)
	tween_alpha.set_loops(flash_count)
	tween_alpha.tween_property(sprite, "self_modulate:a", 0.2, 0.0)
	tween_alpha.tween_property(sprite, "self_modulate:a", 1.0, i_frame_dur)
	
	await get_tree().create_timer(i_frames).timeout
	is_invincible = false

func spawn_projectile():
	var projectile = ray_scene.instantiate()
	projectile.global_position = muzzle.global_position
	projectile.rotation = gun_arm.rotation
	get_tree().current_scene.add_child(projectile)
	
func shoot_logic():
	energy -= shoot_cost
	emit_signal("battery_changed", energy)
	gun_arm.visible = true
	spawn_projectile()
	# Reinicia o timer toda vez que atiramos
	gun_timer.start()

func _gerenciar_sequencia_morte():
	await get_tree().create_timer(1.5).timeout
	emit_signal("morreu")

func _on_gun_timer_timeout() -> void:
	gun_arm.visible = false

func _on_battery_timer_timeout() -> void:
	energy = clamp(energy + 1, 0, 4)
	emit_signal("battery_changed", energy)
	battery_timer.start()
