extends Panel

# 背包数据
@export var inventory: Inventory
@onready var grid_container = $MarginContainer/VBoxContainer/GridContainer
@onready var item_slot_scene = preload("res://components/inventory_slot.tscn")

func _ready() -> void:
	if not inventory:
		inventory = Inventory.new()
		inventory.size = 20
	
	# 创建物品槽
	for i in range(inventory.size):
		var slot = item_slot_scene.instantiate()
		slot.slot_index = i
		grid_container.add_child(slot)
	
	# 连接信号
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)
	inventory.item_changed.connect(_on_item_changed)
	inventory.inventory_updated.connect(_on_inventory_updated)

# 信号处理函数
func _on_item_added(item: InventoryItem, slot: int) -> void:
	var slot_ui = grid_container.get_child(slot)
	slot_ui.set_item(item)

func _on_item_removed(item: InventoryItem, slot: int) -> void:
	var slot_ui = grid_container.get_child(slot)
	slot_ui.clear_item()

func _on_item_changed(item: InventoryItem, slot: int) -> void:
	var slot_ui = grid_container.get_child(slot)
	slot_ui.update_item(item)

func _on_inventory_updated() -> void:
	for i in range(inventory.size):
		var slot_ui = grid_container.get_child(i)
		var item = inventory.get_item(i)
		if item:
			slot_ui.set_item(item)
		else:
			slot_ui.clear_item()

func _on_close_button_pressed() -> void:
	visible = false
