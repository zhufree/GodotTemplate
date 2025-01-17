# 设置界面控制脚本
# 负责管理游戏设置界面的功能
# 主要功能：
# - 音量控制（音效和音乐）
# - 分辨率设置
# - 全屏模式切换
# - 设置的保存和加载

extends Control
@onready var sound_volume = $MarginContainer/VBoxContainer/HBoxContainer2/SoundVolume
@onready var music_volume = $MarginContainer/VBoxContainer/HBoxContainer/MusicVolume

func _ready():
	sound_volume.value = Global.sound_volume
	music_volume.value = Global.music_volume

func _on_sound_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	Global.sound_volume = value


func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	Global.music_volume = value


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_check_button_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED)


func _on_mute_sound_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2, toggled_on)


func _on_mute_music_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1, toggled_on)


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://start.tscn")
