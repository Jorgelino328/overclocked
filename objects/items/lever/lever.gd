extends Area2D

@onready var sprite = $LeverSprite

@export var body_in_range = false
@export var active = false
@export var device : Area2D
@export var device2 : Area2D
var devices = [device,device2]

func _process(delta: float) -> void:
	sprite.frame = active
	if Input.is_action_just_pressed("interact") and body_in_range:
		active = not active
		for d in range(devices.size()):
			if d != null:
				devices[d].active = active

func _on_body_entered(body: Node2D) -> void:
	body_in_range = true


func _on_body_exited(body: Node2D) -> void:
	body_in_range = false
