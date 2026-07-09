extends Enemy

# Define estados possíveis do inimigo
enum State { WALKING, DYING }

const id = 1

@onready var c_bug_animator = $CBugAnimator
@onready var wall_check = $WallCheck
@onready var hurt_sfx = $HurtSFX
@onready var death_sfx = $DeathSFX
@onready var anim_state := State.WALKING
@onready var sprite = $CBugSprite
@onready var doomTracker = $DoomTracker
@onready var explosionRange = $ExplosionRange

var move := Vector2.RIGHT
var turn_speed := 15.0
var knockback := Vector2.ZERO
@export var is_doomed = false

func _physics_process(delta):
	## Reduz knockback aos poucos se houver
	if knockback != Vector2.ZERO:
		knockback = knockback.move_toward(Vector2.ZERO, 50.0 * delta)
	
	if(is_dead):
		anim_state = State.DYING
	else:
		var step_movement = (move * speed * delta) + knockback
		var col := move_and_collide(step_movement) 
		
	
		## Se encontrar parede, gira 90 graus pra cima
		if col and col.get_normal().rotated(PI / 2).dot(move) < 0.5:
			move = col.get_normal().rotated(PI / 2)
			
		else:
			var pos := position
			col = move_and_collide(move.rotated(PI / 2) * 15)
			
			## Se não houver colisão ao tentar se virar pra baixo, gira aos poucos [cite: 2]
			## até achar o chão [cite: 2]
			if not col:
				for i in 10:
					position = pos
					move = move.rotated(PI / 32)
					col = move_and_collide(move.rotated(PI / 2) * 15)
					
					if col:
						move = col.get_normal().rotated(PI / 2)
						break
			else:
				move = col.get_normal().rotated(PI / 2)

		rotation = lerp_angle(rotation, move.angle(), turn_speed * delta)
		
		if is_doomed and doomTracker.is_stopped():
			modulate = Color(16.815, 0.003, 0.002)
			doomTracker.start()
	animation_handler()
		
func animation_handler():
	match anim_state:
		State.WALKING:
			c_bug_animator.play("walk")
			
		State.DYING:
			if c_bug_animator.current_animation != "death":
				c_bug_animator.play("death")
				death_sfx.play()
				for body in explosionRange.get_overlapping_bodies():
					if body is Player:
						body.take_damage(10)
					
func _on_c_bug_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
		
func take_damage(dmg):
	hurt_sfx.play()
	hp -= dmg

func _on_doom_tracker_timeout() -> void:
	hp = 0
