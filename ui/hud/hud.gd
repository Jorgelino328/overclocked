extends CanvasLayer

@onready var container = $HeartContainers
@onready var player = get_parent()

# The source spritesheet PNG
var heart_sheet = preload("res://assets/sprites/simple_heart.png") 

# How much HP 1 full heart represents
const HP_PER_HEART = 10

func _ready():
	player.health_changed.connect(update_hearts)
	setup_hearts()
	update_hearts(player.hp,player.max_hp)

func setup_hearts():
	for child in container.get_children():
		child.queue_free()

	var total_hearts = int(player.max_hp) / int(HP_PER_HEART)
	
	for i in range(total_hearts):
		var new_heart = TextureRect.new()
		var atlas = AtlasTexture.new()
		atlas.atlas = heart_sheet
		atlas.region = Rect2(16, 0, 8, 8) 
		
		new_heart.texture = atlas
		container.add_child(new_heart)

func update_hearts(current_hp, max_hp):
	var hearts = container.get_children()
	
	for i in range(hearts.size()):
		var heart_node = hearts[i]
		var atlas = heart_node.texture as AtlasTexture
		
		var heart_value = (i + 1) * HP_PER_HEART
		
		var hp_left = current_hp - (i * HP_PER_HEART)
		
		if hp_left >= 10:
			print("full")
			atlas.region = Rect2(0, 0, 8, 8)  # Full
		elif hp_left >= 5:
			print("half")
			atlas.region = Rect2(8, 0, 8, 8)  # Half
		else:
			print("empty")
			atlas.region = Rect2(16, 0, 8, 8) # Empty
