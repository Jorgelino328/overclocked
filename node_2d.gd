extends Node2D

@onready var player = $Robonildo
@onready var start_pos = $PontoDeInicio
# @onready var end_zone = $FimDoNivel
# @onready var obstacle_group = $Obstaculos

# func _ready():
# 	# Inicia o jogador na posição segura antes de qualquer perigo
# 	player.global_position = start_pos.global_position
	
# 	# Conecta o sinal da zona final para terminar o nível
# 	# end_zone.body_entered.connect(_on_fim_do_nivel_body_entered)
	
# 	# Conecta os obstáculos provisórios para reiniciar ou causar dano
# 	for obstaculo in obstacle_group.get_children():
# 		if obstaculo is Area2D:
# 			obstaculo.body_entered.connect(_on_obstaculo_body_entered)

# func _on_fim_do_nivel_body_entered(body):
# 	if body.name == "Robonildo":
# 		print("Fase Finalizada com sucesso! Preparando para o Nível 2...")
# 		# Lógica futura: get_tree().change_scene_to_file("res://Level_2.tscn")

# func _on_obstaculo_body_entered(body):
# 	if body.name == "Robonildo":
# 		print("Robonildo tocou no obstáculo provisório!")
# 		# Para o protótipo básico, volta o jogador para o início
# 		# Mais tarde, chamará a função take_damage do player
# 		body.global_position = start_pos.global_position
