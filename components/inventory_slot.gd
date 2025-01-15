extends Panel

var slot_index: int = 0
var item: InventoryItem = null

@onready var icon = $TextureRect
@onready var amount_label = $AmountLabel

func set_item(new_item: InventoryItem) -> void:
	item = new_item
	print(item.icon)
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
		# TODO: 显示物品提示信息
		pass

# 鼠标离开
func _on_mouse_exited() -> void:
	if item:
		# TODO: 隐藏物品提示信息
		pass

# 点击处理
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# TODO: 处理点击事件（装备、使用等）
			pass
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			# TODO: 处理右键点击（显示上下文菜单等）
			pass
