extends HBoxContainer

@onready var player = get_parent().get_parent().get_parent()

# The source spritesheet PNG
var heart_sheet = preload("res://assets/sprites/cog_hp.png") 
var current_max := 10

# How much HP 1 full heart represents
const HP_PER_HEART = 10

func _ready():
	player.health_changed.connect(update_hearts)
	setup_hearts()
	update_hearts(player.hp,player.max_hp)

func setup_hearts():
	for child in get_children():
		child.queue_free()
	
	current_max = player.max_hp
	var total_hearts = int(player.max_hp) / int(HP_PER_HEART)
	for i in range(total_hearts):
		var new_heart = TextureRect.new()
		
		# Create a unique AtlasTexture for every heart
		var atlas = AtlasTexture.new()
		atlas.atlas = heart_sheet
		atlas.region = Rect2(32, 0, 16, 16) 
		
		new_heart.texture = atlas
		add_child(new_heart)

func update_hearts(current_hp, max_hp):
	# Ensure hearts are set up for the current max health 
	if max_hp != current_max:
		setup_hearts()
	
	var hearts = get_children()
	for i in range(hearts.size()):
		var heart_node = hearts[i]
		var atlas = heart_node.texture as AtlasTexture
		
		# Calculate HP contribution for this heart 
		var hp_left = current_hp - (i * HP_PER_HEART)
		
		# Update region based on remaining HP 
		if hp_left >= 10:
			atlas.region = Rect2(0, 0, 16, 16)  # Full 
		elif hp_left >= 5:
			atlas.region = Rect2(16, 0, 16, 16) # Half 
		else:
			atlas.region = Rect2(32, 0, 16, 16) # Empty 
			
		# FORCE the node to update its visual representation
		heart_node.texture = null
		heart_node.texture = atlas
