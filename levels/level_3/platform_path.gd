extends Path2D
@onready var animation = $PathAnimator
@onready var parent_level = get_parent()

var is_active = false
var path_assembled =  true

func _process(_delta) -> void:
	is_active = parent_level.is_active
	if is_active and path_assembled:
		animation.play("earthquake")
		path_assembled = false
	if not is_active and not path_assembled:
		animation.play_backwards("earthquake")
		path_assembled = true
		
