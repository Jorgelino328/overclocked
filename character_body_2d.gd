extends CharacterBody2D

# Variáveis base do Nível 1 - Estado: Apenas Placa-Mãe
const SPEED = 150.0 # Movimentação lenta
const JUMP_VELOCITY = -300.0 # Pulo suficiente para passar 2 blocos de altura

# Variáveis de Estado do Sistema
var has_power_supply: bool = false
var has_processor: bool = false
var has_hard_drive: bool = false
var is_damaged: bool = false
var current_health: float = 1.0 # 1 coração (2 hits)
var current_backups: int = 10 # 10 tentativas por nível

# Gravidade padrão do projeto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Aplica a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Lida com o salto
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Obtém a direção do input (esquerda/direita)
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Função simples para receber dano (0.5 = meio coração)
func take_damage(amount: float = 0.5):
	if not is_damaged:
		current_health -= amount
		print("Dano recebido! Vida atual: ", current_health)
		# Aqui no futuro você adicionará os i-frames e a lógica de morte/backup
