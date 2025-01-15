extends Control

@onready var inventory_ui = $Inventory

# 测试物品数据
var test_items = [
	{
		"id": "health_potion",
		"name": "helmet",
		"description": "A helmet",
		"icon": preload("res://assets/images/item_helmet.png"),
		"stack_size": 99,
		"type": "weapon",
		"rarity": 1
	},
	{
		"id": "mana_potion",
		"name": "bow",
		"description": "A bow",
		"icon": preload("res://assets/images/item_bow.png"),
		"stack_size": 99,
		"type": "weapon",
		"rarity": 1
	},
	{
		"id": "sword",
		"name": "sword",
		"description": "A sword",
		"icon": preload("res://assets/images/item_sword.png"),
		"stack_size": 99,
		"type": "weapon",
		"rarity": 2
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_open_inventory_button_pressed() -> void:
	inventory_ui.visible = true


# 创建测试物品实例
func create_test_item(item_data: Dictionary) -> InventoryItem:
	var item = InventoryItem.new()
	item.id = item_data.id
	item.name = item_data.name
	item.description = item_data.description
	item.icon = item_data.icon
	item.stack_size = item_data.stack_size
	item.type = item_data.type
	item.rarity = item_data.rarity
	# 随机生成堆叠数量
	item.current_stack = randi_range(1, item.stack_size)
	return item

func _on_add_item_button_pressed() -> void:
	# 随机选择一个测试物品
	var random_item_data = test_items[randi() % test_items.size()]
	var item = create_test_item(random_item_data)
	
	# 添加到背包
	if inventory_ui.inventory.add_item(item):
		print("添加物品成功：", item.name, " x", item.current_stack)
	else:
		print("背包已满！")
