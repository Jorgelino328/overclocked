extends Collectable

func is_already_collected(body: Player) -> bool:
	print("already collected")
	return body.has_ram

func mark_as_collected(body: Player) -> void:
	print("ram collected")
	body.has_ram = true
