extends Hazard

@onready var cluster = $GlitchCluster
@onready var animation = $AnimationPlayer
@onready var hurt_sfx = $HurtSFX

func _ready():
	hp = 15
	animation.play("glitch")

func _process(_delta):
	super._process(_delta)
	var children_amnt = cluster.get_children().size()
	if (hp <= 10 && children_amnt == 7 || hp <= 5 && children_amnt == 5):
		for i in range (2):
			var r_kill = randi() % cluster.get_children().size() - 1
			cluster.get_child(r_kill).queue_free()
	if is_destroyed:
		despawn()
		
func take_damage(dmg):
	hurt_sfx.play()
	hp -= dmg
