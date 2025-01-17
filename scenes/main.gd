# 主场景控制脚本
# 负责管理游戏主场景的功能
# 主要功能：
# - 初始化游戏场景
# - 播放背景音乐
# - 管理场景转换

extends Control
@onready var game_bgm_player: AudioStreamPlayer2D = $GameBGMPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_bgm_player.play()
