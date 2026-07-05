extends Node2D


var speed = 2  # rotation speed (in radians)
var radius = 100  # desired orbit radius
func _ready():
	position = Vector2(radius, 0) # desired orbit radius

func _process(delta):
	rotation += speed * delta
