extends CharacterBody2D

# Variáveis costumizáveis no Inspector do Godot 
@export var speed_slow := 100.0
@export var speed_walk := 300.0
@export var speed_run := 600.0
@export var jump_velocity := -600.0

# Variáveis definidas ao inicializar Node
@onready var current_speed := speed_walk
@onready var animation_player = $RobonildoAnimator
@onready var sprite = $RobonildoSprite

# Define estados possíveis do personagem
enum State { IDLE, WALKING , RUNNING , JUMPING , DYING}

# Pega valor de gravidade definida nas configurações do projeto.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Inicia o jogo no estado Idle
var anim_state := State.IDLE


var time_walking := 0.0
var time_running := 0.0
var time_idle := 0.0
var sideways := false

func _physics_process(delta):
	# Adiciona gravidade caso esteja fora do chão.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# TEST: O IF statement abaixo existe apenas para testar a animação de morte.
	# Lembre-se de removê-lo, junto do input "test_death_anim" nas configurações
	# do projeto quando o sistema de HP e morte estiverem devidamente implementados.
	if Input.is_action_just_pressed("test_death_anim"):
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
			velocity.y = jump_velocity
			anim_state = State.JUMPING 
			
		# Se está se movendo no chão
		elif direction:
			sideways = true
			anim_state = State.WALKING if anim_state != State.RUNNING else State.RUNNING
			
		# Se  está parado no chão
		else:
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
	else:
		# Garante que a velocidade seja zerada ao morrer
		velocity.x = 0.0
		
	# Função de movimento padrão do Godot com colisão simples 
	# onde um corpo "desliza" do outro ao colidir.
	move_and_slide()

func animation_handler(direction,delta):
	# Vira o sprite caso esteja indo pra esquerda.
	if direction != 0:
		sprite.flip_h = (direction < 0)
	
	# Define animação baseado no estado
	match anim_state:
		State.IDLE:
			# Quando acaba de parar (Frame 0).
			if time_idle == 0.0:
				if sideways:
					animation_player.play("RESET_side") # Fica congelado virado de lado.
				else:
					animation_player.play("RESET") # Fica congelado virado de frente.

			# Após 1 segundo parado
			if time_idle < 1.0 and (time_idle + delta) >= 1.0:
				# Se estiver de lado, se vira e toca animação idle.
				if sideways:
					animation_player.play("idle_turn")
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
			# Se vira e começa a andar.
			if time_walking == 0.0:
				animation_player.play("walk_turn")
				animation_player.queue("walk")
			
			# Acelera quando estiver andando, mas para enquanto a animação de início estiver tocando.
			if animation_player.current_animation == "walk":
				current_speed = speed_walk
			elif animation_player.current_animation == "walk_turn" :
				current_speed = speed_slow
			
			# Atualiza os timers.
			time_walking += delta
			time_running = 0.0
			time_idle = 0.0
			
			# Após 2 segundos andando, começa a correr.
			if time_walking >= 2.0:
				anim_state = State.RUNNING
				
		State.RUNNING:
			# Se vira e começa a correr.
			if time_walking >= 0.0 and time_running == 0.0:
				animation_player.play("run_start")
				animation_player.queue("run")
			
			# Acelera quando estiver correndo.
			if animation_player.current_animation == "run":
				current_speed = speed_run
			
			# Atualiza os timers.
			time_walking = 0.0
			time_running += delta 
			time_idle = 0.0
			
			# TODO: Add animation for stopping from run for smoother transition.
			
		State.JUMPING:
			# TODO: Implementar mecânica de pulo.
			pass
		State.DYING:
			# WARNING: Sistema de HP ainda não implementado, 
			# a única maneira de entrar nesse estado no momento é pressionando a tecla 0 no teclado.
			
			# Toca animação de morte caso já não tenha tocado.
			if animation_player.current_animation != "death":
				animation_player.play("death")
				
			# TODO: Implementar animações diferentes para morte enquanto corre/anda/pula.
