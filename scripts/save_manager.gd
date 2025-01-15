# save_manager.db
extends Node

var save_file_path = ProjectSettings.globalize_path("user://") # production
#var save_file_path = ProjectSettings.globalize_path("res://") # test
var save_file_name = "save.tres"
var save_data = SaveData.new()


func save_level_index(_latest_level):
	save_data.latest_level = _latest_level
	save()

func get_level_index():
	return save_data.latest_level


func save_language(_language):
	save_data.language = _language
	save()

func get_language():
	return save_data.language

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func load_save_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		save_data = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		print('save data loaded')

func save():
	ResourceSaver.save(save_data, save_file_path + save_file_name)
	print('data saved')

# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(save_file_path)
	load_save_data()
