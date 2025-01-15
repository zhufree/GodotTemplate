extends Resource
class_name InventoryItem

# 物品基本属性
@export var id: String = ""  # 物品唯一标识符
@export var name: String = ""  # 物品名称
@export var description: String = ""  # 物品描述
@export var icon: Texture2D  # 物品图标
@export var stack_size: int = 1  # 最大堆叠数量
@export var type: String = ""  # 物品类型（装备、消耗品、材料等）
@export var rarity: int = 0  # 物品稀有度

# 物品状态
@export var current_stack: int = 1  # 当前堆叠数量
@export var equipped: bool = false  # 是否已装备

# 物品属性（可选）
@export var properties: Dictionary = {}  # 自定义属性字典

# 获取物品完整信息
func get_item_info() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"type": type,
		"rarity": rarity,
		"stack_size": stack_size,
		"current_stack": current_stack,
		"equipped": equipped,
		"properties": properties
	}

# 检查是否可以堆叠
func can_stack_with(other_item: InventoryItem) -> bool:
	return id == other_item.id and current_stack < stack_size

# 添加到堆叠
func add_to_stack(amount: int) -> int:
	var space_left = stack_size - current_stack
	var actual_add = min(amount, space_left)
	current_stack += actual_add
	return actual_add  # 返回实际添加的数量

# 从堆叠中移除
func remove_from_stack(amount: int) -> int:
	var actual_remove = min(amount, current_stack)
	current_stack -= actual_remove
	return actual_remove  # 返回实际移除的数量

# 克隆物品
func clone() -> InventoryItem:
	var new_item = duplicate()
	new_item.current_stack = 1
	new_item.equipped = false
	return new_item

# 检查物品是否有效
func is_valid() -> bool:
	return id != "" and name != "" and current_stack > 0
