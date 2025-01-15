extends Control

@onready var inventory_ui = $Inventory

# 测试物品数据
var test_items = [
	{
		"id": "health_potion",
		"name": "生命药水",
		"description": "恢复50点生命值",
		"stack_size": 10,
		"type": "consumable",
		"rarity": 1
	},
	{
		"id": "mana_potion",
		"name": "魔法药水",
		"description": "恢复30点魔法值",
		"stack_size": 10,
		"type": "consumable",
		"rarity": 1
	},
	{
		"id": "sword",
		"name": "铁剑",
		"description": "普通的铁剑",
		"stack_size": 1,
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
