extends Control
@onready var game_bgm_player: AudioStreamPlayer2D = $GameBGMPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_bgm_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
