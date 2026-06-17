extends StaticBody2D

@onready var animator = $CoolerAnimator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("cooler")
