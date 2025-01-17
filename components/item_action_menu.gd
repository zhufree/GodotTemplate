extends PanelContainer

signal action_selected(action_name: String, slot_index: int)

var slot_index: int = -1

@onready var button_container = $MarginContainer/VBoxContainer

# 定义可用的操作
const ACTIONS = {
	"use": {"text_key": "ITEM_ACTION_USE", "icon": null},
	"drop": {"text_key": "ITEM_ACTION_DROP", "icon": null},
}

func _ready() -> void:
	# 确保菜单初始时是隐藏的
	hide()
	mouse_filter = Control.MOUSE_FILTER_STOP
	setup()

func setup(actions: Dictionary = ACTIONS) -> void:
	# 清除现有按钮
	for child in button_container.get_children():
		child.queue_free()
	
	# 创建新按钮
	for action_id in actions:
		var action = actions[action_id]
		var button = Button.new()
		button.text = tr(action.text_key)
		if action.icon:
			button.icon = action.icon
		button.pressed.connect(_on_action_button_pressed.bind(action_id))
		button_container.add_child(button)

func show_at_position(pos: Vector2, new_slot_index: int) -> void:
	slot_index = new_slot_index
	global_position = pos
	show()
	# 添加一个延迟的点击检测，避免立即触发隐藏
	get_tree().create_timer(0.1).timeout.connect(
		func(): set_process_input(true)
	)

func _input(event: InputEvent) -> void:
	if not visible:
		set_process_input(false)
		return
		
	if event is InputEventMouseButton:
		if event.pressed:
			var click_pos = get_viewport().get_mouse_position()
			var menu_rect = get_global_rect()
			if not menu_rect.has_point(click_pos):
				hide()
				set_process_input(false)

func _on_action_button_pressed(action_id: String) -> void:
	action_selected.emit(action_id, slot_index)
	hide()
	set_process_input(false)
