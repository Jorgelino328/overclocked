## Define o script do jogador como uma classe do tipo "Player", para facilitar identificação
class_name Player extends CharacterBody2D

# Variáveis costumizáveis no Inspector do Godot 
@export var speed_walk := 300.0
@export var speed_run := 600.0
@export var jump_velocity := -600.0
@export var hp := 10
@export var i_frames := 1
@export var i_frame_dur = 0.2

# Variáveis definidas ao inicializar Node
@onready var current_speed := speed_walk
@onready var animation_player = $RobonildoAnimator
@onready var sprite = $RobonildoSprite
@onready var hurt_sfx = $SFX/HurtSFX
@onready var jump_sfx = $SFX/JumpSFX
@onready var rocket_sfx = $SFX/RocketSFX

# Define estados possíveis do personagem
enum State { IDLE, WALKING, RUNNING, JUMPING, LOOKING, DYING}

# Pega valor de gravidade definida nas configurações do projeto.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Inicia o jogo no estado Idle
var anim_state := State.IDLE

var time_walking := 0.0
var time_running := 0.0
var time_idle := 0.0
var just_jumped := false
var sideways := false
var dead_anim := false
var knockback = Vector2.ZERO
var is_invincible = false

func _physics_process(delta):
	# Adiciona gravidade caso esteja fora do chão.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Se a HP do jogador chega a 0, toca a animação de morte
	if hp <= 0:
		anim_state = State.DYING
		
	# Pega a direção do input
	var direction := Input.get_axis("walk_left", "walk_right")

	# Se o personagem estiver vivo, decide o estado atual
	if anim_state != State.DYING:
		
		# Se está no ar 
		if not is_on_floor():
			anim_state = State.JUMPING
		
		# Se acabou de pular
		elif Input.is_action_just_pressed("jump"):
			just_jumped = true
			anim_state = State.JUMPING
			velocity.y = jump_velocity
		
		# Se está olhando pra cima ou pra baixo
		elif Input.is_action_pressed("look_up") or Input.is_action_pressed("look_down") :
			anim_state = State.LOOKING
			
		# Se está se movendo no chão
		elif direction:
			sideways = true
			anim_state = State.WALKING if anim_state != State.RUNNING else State.RUNNING
			
		# Se  está parado no chão
		elif anim_state != State.LOOKING:
			anim_state = State.IDLE
			
	# Aciona as animações PRIMEIRO, pois elas alteram a variável de velocidade. 
	animation_handler(direction, delta)
	
	# Se o personagem estiver vivo, aplica o movimento
	if anim_state != State.DYING:
		# Aplica a velocidade x usando o "current_speed" atualizado pelo handler
		if direction:
			velocity.x = direction * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
		
		# Aplica o Knockback, se houver
		velocity += knockback
	else:
		# Garante que a velocidade seja zerada ao morrer
		velocity.x = 0.0
		
	# Função de movimento padrão do Godot com colisão simples 
	# onde um corpo "desliza" do outro ao colidir.
	move_and_slide()

func animation_handler(direction,delta):
	# Vira o sprite caso esteja indo pra esquerda.
	if direction != 0 and anim_state != State.DYING:
		sprite.flip_h = (direction < 0)
	
	# Para o loop de foguete ao parar de correr
	if time_running <= 0:
		rocket_sfx.stop() 
	
	# Define animação baseado no estado
	match anim_state:
		State.IDLE:
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
					
			# Atualiza os timers.
			time_walking = 0.0
			time_running = 0.0
			time_idle += delta
			
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
			
		State.JUMPING:
			# Se vira e começa a correr.
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

func take_damage(dmg):
	if is_invincible:
		return
	
	hurt_sfx.play()
	hp -= dmg
	is_invincible = true

	var tween_alpha = create_tween()
	
	var flash_count: int = int(i_frames / i_frame_dur)
	
	tween_alpha.set_loops(flash_count)
	
	tween_alpha.tween_property(sprite, "self_modulate:a", 0.2, 0.0)
	tween_alpha.tween_property(sprite, "self_modulate:a", 1.0, i_frame_dur)
	
	await get_tree().create_timer(i_frames).timeout
	is_invincible = false
