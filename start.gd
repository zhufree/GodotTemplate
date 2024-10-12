extends Control

@export var background_color: Color = Color.AQUA
@export var title_color: Color = Color.WHITE
@export var subtitle_color: Color = Color.ANTIQUE_WHITE
@export var title_font_size: int = 80
@export var subtitle_font_size: int = 40
@onready var color_rect: ColorRect = $ColorRect
@onready var game_title: Label = $MarginContainer/VBoxContainer/GameTitle
@onready var game_subtitle: Label = $MarginContainer/VBoxContainer/GameSubtitle
@onready var menu_bgm_player: AudioStreamPlayer2D = $MenuBGMPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.color = background_color
	game_title.add_theme_color_override("font_color", title_color)
	game_subtitle.add_theme_color_override("font_color", subtitle_color)
	game_title.add_theme_font_size_override("font_size", title_font_size)
	game_subtitle.add_theme_font_size_override("font_size", subtitle_font_size)
	menu_bgm_player.play()


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_setting_button_pressed() -> void:
	get_tree().change_scene_to_file("res://setting.tscn")


func _on_credit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://credit.tscn")
