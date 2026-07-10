extends PathFollow2D

@onready var path = get_parent()
@export var speed = 25

func _process(delta):
	if path.is_active:
		self.progress += (speed * delta)
