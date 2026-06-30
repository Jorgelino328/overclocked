extends HBoxContainer

@onready var player = get_parent().get_parent().get_parent()

# The source spritesheet PNG
var heart_sheet = preload("res://assets/sprites/cog_hp.png") 

# How much HP 1 full heart represents
const HP_PER_HEART = 10

func _ready():
	player.health_changed.connect(update_hearts)
	setup_hearts()
	update_hearts(player.hp,player.max_hp)

func setup_hearts():
	for child in get_children():
		child.queue_free()

	var total_hearts = int(player.max_hp) / int(HP_PER_HEART)
	
	for i in range(total_hearts):
		var new_heart = TextureRect.new()
		var atlas = AtlasTexture.new()
		atlas.atlas = heart_sheet
		atlas.region = Rect2(16, 0, 8, 8) 
		
		new_heart.texture = atlas
		add_child(new_heart)

func update_hearts(current_hp, max_hp):
	var hearts = get_children()
	
	for i in range(hearts.size()):
		var heart_node = hearts[i]
		var atlas = heart_node.texture as AtlasTexture
		
		var heart_value = (i + 1) * HP_PER_HEART
		
		var hp_left = current_hp - (i * HP_PER_HEART)
		
		if hp_left >= 10:
			atlas.region = Rect2(0, 0, 16, 16)  # Full
		elif hp_left >= 5:
			atlas.region = Rect2(16, 0, 16, 16)  # Half
		else:
			atlas.region = Rect2(32, 0, 16, 16) # Empty
