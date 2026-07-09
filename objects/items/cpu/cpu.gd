extends Collectable

func is_already_collected(body: Player) -> bool:
	return body.has_cpu

func mark_as_collected(body: Player) -> void:
	body.has_cpu = true
