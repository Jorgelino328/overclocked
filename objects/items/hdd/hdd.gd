extends Collectable

func is_already_collected(body: Player) -> bool:
	return body.has_hdd

func mark_as_collected(body: Player) -> void:
	body.has_hdd = true
