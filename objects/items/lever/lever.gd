extends Area2D

@onready var sprite = $LeverSprite

@export var body_in_range = false
@export var active = false
@export var devices : Array[Area2D] 

func _process(delta: float) -> void:
	sprite.frame = int(active) 
	
	if Input.is_action_just_pressed("interact") and body_in_range:
		active = not active
		for device in devices:
			if device and "active" in device:
				device.active = active

func _on_body_entered(body: Node2D) -> void:
	body_in_range = true

func _on_body_exited(body: Node2D) -> void:
	body_in_range = false
