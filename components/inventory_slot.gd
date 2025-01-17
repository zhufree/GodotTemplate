# 背包格子UI组件
# 负责显示和管理单个背包格子的内容和交互
# 主要功能：
# - 显示物品图标和数量
# - 处理物品的设置和清除
# - 管理拖放操作
# - 更新物品堆叠数量显示
# - 显示物品详情提示框

extends Panel

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

# 鼠标进入
func _on_mouse_entered() -> void:
	if item:
		tooltip_name.text = item.name
		tooltip_type.text = item.type
		tooltip_description.text = item.description
		tooltip_panel.show()

# 鼠标离开
func _on_mouse_exited() -> void:
	tooltip_panel.hide()

# 点击处理
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# TODO: 处理点击事件（装备、使用等）
			pass
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			# TODO: 处理右键点击（显示上下文菜单等）
			pass
