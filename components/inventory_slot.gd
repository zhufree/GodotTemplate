# 背包格子UI组件
# 负责显示和管理单个背包格子的内容和交互
# 主要功能：
# - 显示物品图标和数量
# - 处理物品的设置和清除
# - 管理拖放操作
# - 更新物品堆叠数量显示
# - 显示物品详情提示框

extends Panel

signal item_dropped(from_slot: int, to_slot: int)
signal action_requested(action: String, slot_index: int)

var slot_index: int = 0
var item: InventoryItem = null

@onready var icon = $TextureRect
@onready var amount_label = $AmountLabel
@onready var tooltip_panel = $TooltipPanel
@onready var tooltip_name = $TooltipPanel/VBoxContainer/ItemName
@onready var tooltip_type = $TooltipPanel/VBoxContainer/ItemType
@onready var tooltip_description = $TooltipPanel/VBoxContainer/ItemDescription
var menu_scene = preload("res://components/item_action_menu.tscn")

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	mouse_filter = Control.MOUSE_FILTER_STOP

func set_item(new_item: InventoryItem) -> void:
	item = new_item
	if item:
		icon.texture = item.icon
		update_amount()
		show()
	else:
		clear_item()

func clear_item() -> void:
	item = null
	icon.texture = null
	amount_label.text = ""
	tooltip_panel.hide()

func update_item(updated_item: InventoryItem) -> void:
	item = updated_item
	update_amount()

func update_amount() -> void:
	if item and item.stack_size > 1:
		amount_label.text = str(item.current_stack)
	else:
		amount_label.text = ""

func _on_mouse_entered() -> void:
	if item and not get_viewport().gui_is_dragging():
		tooltip_name.text = item.name
		tooltip_type.text = item.type
		tooltip_description.text = item.description
		tooltip_panel.show()

func _on_mouse_exited() -> void:
	tooltip_panel.hide()

func _get_drag_data(_position: Vector2) -> Variant:
	if item:
		tooltip_panel.hide()
		
		# 创建拖动预览
		var preview = TextureRect.new()
		preview.texture = item.icon
		preview.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		preview.modulate = Color(1, 1, 1, 0.8)
		preview.scale = Vector2(0.5, 0.5)
		
		var control = Control.new()
		control.add_child(preview)
		
		# 计算预览的实际大小
		var preview_size = preview.texture.get_size() * preview.scale
		# 将预览居中到鼠标位置
		preview.position = -preview_size / 2
		
		set_drag_preview(control)
		
		# 隐藏任何打开的菜单
		var menu = get_node_or_null("/root/ItemActionMenu")
		if menu:
			menu.hide()
			
		return {"slot_index": slot_index}
	return null

func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return data is Dictionary and data.has("slot_index")

func _drop_data(_position: Vector2, data: Variant) -> void:
	if data is Dictionary and data.has("slot_index"):
		item_dropped.emit(data.slot_index, slot_index)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT and item:
			tooltip_panel.hide()
			# 显示操作菜单
			var menu = get_node_or_null("/root/ItemActionMenu")
			if menu:
				menu.queue_free() # 删除旧的菜单
			
			# 创建新菜单
			menu = menu_scene.instantiate()
			get_tree().root.add_child(menu)
			menu.name = "ItemActionMenu"
			menu.action_selected.connect(_on_action_selected)
			
			# 计算菜单位置（在物品图标右侧）
			var menu_pos = global_position + Vector2(size.x + 5, 0)
			menu.show_at_position(menu_pos, slot_index)

func _on_action_selected(action: String) -> void:
	# 直接发送当前的slot_index，因为菜单是刚刚创建的，所以slot_index一定是正确的
	action_requested.emit(action, slot_index)
