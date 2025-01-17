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

var slot_index: int = 0
var item: InventoryItem = null

@onready var icon = $TextureRect
@onready var amount_label = $AmountLabel
@onready var tooltip_panel = $TooltipPanel
@onready var tooltip_name = $TooltipPanel/MarginContainer/VBoxContainer/ItemName
@onready var tooltip_type = $TooltipPanel/MarginContainer/VBoxContainer/ItemType
@onready var tooltip_description = $TooltipPanel/MarginContainer/VBoxContainer/ItemDescription

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
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

func _get_drag_data(position: Vector2) -> Variant:
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
		return {"slot_index": slot_index}
	return null

func _can_drop_data(_position: Vector2, _data: Variant) -> bool:
	return true  # 总是允许拖放，这样鼠标不会显示禁用图标

func _drop_data(position: Vector2, data: Variant) -> void:
	if data is Dictionary and data.has("slot_index"):
		item_dropped.emit(data.slot_index, slot_index)
