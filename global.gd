extends Node

var music_volume = 0
var sound_volume = 0

var saved_game: SavedGame

func _ready() -> void:
	load_data()
	print("load data: ", saved_game)

func load_data() -> void:
	if ResourceLoader.exists("user://saved_game.tres"):
		saved_game = ResourceLoader.load("user://saved_game.tres")
	else:
		saved_game = SavedGame.new()

func init_data() -> void:
	saved_game = SavedGame.new()
