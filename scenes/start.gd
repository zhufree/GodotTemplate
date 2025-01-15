extends Control

@export var background_color: Color = Color.AQUA
@export var title_color: Color = Color.WHITE
@export var subtitle_color: Color = Color.ANTIQUE_WHITE
@export var title_font_size: int = 80
@export var subtitle_font_size: int = 40
@onready var color_rect: ColorRect = $ColorRect
@onready var menu_bgm_player: AudioStreamPlayer2D = $MenuBGMPlayer
@onready var game_title: Label = $MarginContainer/VBoxContainer/GameTitle
@onready var game_subtitle: Label = $MarginContainer/VBoxContainer/GameSubtitle
@onready var play_button: Button = $MarginContainer/VBoxContainer/MarginContainer/MenuButtonGroup/PlayButton
@onready var setting_button: Button = $MarginContainer/VBoxContainer/MarginContainer/MenuButtonGroup/SettingButton
@onready var credit_button: Button = $MarginContainer/VBoxContainer/MarginContainer/MenuButtonGroup/CreditButton
@onready var exit_button: Button = $MarginContainer/VBoxContainer/MarginContainer/MenuButtonGroup/ExitButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.color = background_color
	game_title.add_theme_color_override("font_color", title_color)
	game_subtitle.add_theme_color_override("font_color", subtitle_color)
	game_title.add_theme_color_override("font_size", title_font_size)
	game_subtitle.add_theme_color_override("font_size", subtitle_font_size)
	menu_bgm_player.play()
	TranslationServer.set_locale(SaveManager.get_language())
	
	play_button.pressed.connect(_on_play_pressed)
	setting_button.pressed.connect(_on_setting_pressed)
	credit_button.pressed.connect(_on_credit_pressed)
	exit_button.pressed.connect(_on_quit_pressed)

func _on_language_changed():
	if SaveManager.get_language() == 'zh_CN':	
		SaveManager.save_language('en')
		TranslationServer.set_locale('en')
	else:
		SaveManager.save_language('zh_CN')
		TranslationServer.set_locale('zh_CN')


func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_setting_pressed():
	get_tree().change_scene_to_file("res://setting.tscn")

func _on_credit_pressed():
	get_tree().change_scene_to_file("res://credit.tscn")

func _on_quit_pressed():
	get_tree().quit()
