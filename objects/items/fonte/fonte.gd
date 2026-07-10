extends Collectable

func is_already_collected(body: Player) -> bool:
	return body.has_psu

func mark_as_collected(body: Player) -> void:
	body.has_psu = true
