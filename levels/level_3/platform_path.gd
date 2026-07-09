extends Path2D
@onready var animation = $PathAnimator

var is_active = false
var path_assembled =  true

func _process(delta: float) -> void:
	if is_active and path_assembled:
		animation.play("earthquake")
		path_assembled = false
	if not is_active and not path_assembled:
		animation.play_backwards("earthquake")
		path_assembled = true
		
