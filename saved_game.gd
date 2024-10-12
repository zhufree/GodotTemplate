extends Resource
class_name SavedGame

@export var latest_level: String = "res://scenes/level/level_1.tscn"
@export var items: Array = [null, null, null, null, null, null, null, null, null]

func save_level_data(_latest_level, _items) -> void:
	if _latest_level:
		latest_level = _latest_level
	items = _items
	_save()

func save_store_data(_items) -> void:
	items = _items
	_save()

func _save() -> void:
	ResourceSaver.save(self, "user://saved_game.tres")
