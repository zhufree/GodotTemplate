# 背包系统UI组件
# 负责管理和显示背包界面，处理物品的显示和交互
# 主要功能：
# - 创建和初始化背包格子
# - 处理物品的添加、移除和更新
# - 响应背包数据变化并更新UI
# - 处理拖放操作和物品堆叠

extends Panel

# 背包数据
@export var inventory: Inventory
@onready var grid_container = $MarginContainer/VBoxContainer/GridContainer
@onready var item_slot_scene = preload("res://components/inventory_slot.tscn")

func _ready() -> void:
	if not inventory:
		inventory = Inventory.new()
		inventory.size = 45
	
	# 连接信号
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)
	inventory.item_changed.connect(_on_item_changed)
	inventory.items_swapped.connect(_on_items_swapped)
	inventory.inventory_updated.connect(_on_inventory_updated)
	
	_create_slots()
	_on_inventory_updated()

func _create_slots() -> void:
	for i in range(inventory.size):
		var slot = item_slot_scene.instantiate()
		slot.slot_index = i
		slot.item_dropped.connect(_on_item_dropped)
		slot.action_requested.connect(_on_item_action_requested)
		grid_container.add_child(slot)

# 信号处理函数
func _on_item_added(item: InventoryItem, slot: int) -> void:
	var slot_ui = grid_container.get_child(slot)
	slot_ui.set_item(item)

func _on_item_removed(_item: InventoryItem, slot: int) -> void:
	var slot_ui = grid_container.get_child(slot)
	slot_ui.clear_item()

func _on_item_changed(item: InventoryItem, slot: int) -> void:
	var slot_ui = grid_container.get_child(slot)
	slot_ui.update_item(item)

func _on_items_swapped(_from_slot: int, _to_slot: int) -> void:
	_on_inventory_updated()

func _on_inventory_updated() -> void:
	for i in range(inventory.size):
		var slot_ui = grid_container.get_child(i)
		if inventory.slots[i]:
			slot_ui.set_item(inventory.slots[i])
		else:
			slot_ui.clear_item()

func _on_item_dropped(from_slot: int, to_slot: int) -> void:
	inventory.move_item(from_slot, to_slot)

func _on_item_action_requested(action: String, slot_index: int) -> void:
	var item = inventory.slots[slot_index]
	var slot_ui = grid_container.get_child(slot_index)
	if not item:
		return
		
	match action:
		"use":
			print("使用物品:", item.name)  # 这里添加使用物品的逻辑
			item.remove_from_stack(1)
		"drop":
			item.remove_from_stack(1)
			print("丢弃物品:", item.name)  # 这里添加丢弃物品的逻辑
		_:
			printerr("未知的操作:" + action)
	slot_ui.update_item(item)

func _can_drop_data(_position: Vector2, _data: Variant) -> bool:
	return true  # 总是允许拖放，保持鼠标光标不变

func _drop_data(_position: Vector2, _data: Variant) -> void:
	pass  # 不做任何处理，只是为了防止禁用光标

func _on_close_button_pressed() -> void:
	visible = false
