extends Enemy


# Define estados possíveis do inimigo
enum State {WALKING, DYING}

@onready var c_bug_animator = $CBugAnimator

# Inicia o jogo no estado Idle
@onready var anim_state := State.WALKING

func _physics_process(delta):
	if(is_dead):
		anim_state = State.DYING
		
func animation_handler():
	match anim_state:
		State.WALKING:
			c_bug_animator.play("walk")
		State.DYING:
			c_bug_animator.play("death")
