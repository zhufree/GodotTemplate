# 背包的数据模型，可用于不同类型的背包
extends Resource
class_name Inventory

# 信号
signal item_added(item: InventoryItem, slot: int)
signal item_removed(item: InventoryItem, slot: int)
signal item_changed(item: InventoryItem, slot: int)
signal items_swapped(from_slot: int, to_slot: int)
signal inventory_updated()

# 属性
@export var size: int = 45  # 背包大小
var slots: Array[InventoryItem]  # 物品槽数组

func _init():
	# 初始化空物品槽
	slots.resize(size)

# 添加物品到背包
func add_item(item: InventoryItem) -> bool:
	# 先尝试堆叠
	if item.stack_size > 1:
		var similar_slot = find_similar_item(item)
		if similar_slot != -1:
			var existing_item = slots[similar_slot]
			var space_left = existing_item.stack_size - existing_item.current_stack
			if space_left > 0:
				var amount_to_add = min(space_left, item.current_stack)
				existing_item.current_stack += amount_to_add
				item.current_stack -= amount_to_add
				emit_signal("item_changed", existing_item, similar_slot)
				
				if item.current_stack == 0:
					emit_signal("inventory_updated")
					return true
	
	# 如果还有剩余物品，找一个空位
	var empty_slot = find_empty_slot()
	if empty_slot != -1:
		slots[empty_slot] = item
		emit_signal("item_added", item, empty_slot)
		emit_signal("inventory_updated")
		return true
	
	return false

# 从背包移除物品
func remove_item(slot: int) -> InventoryItem:
	if slot < 0 or slot >= size:
		return null
	
	var item = slots[slot]
	if item:
		slots[slot] = null
		emit_signal("item_removed", item, slot)
		emit_signal("inventory_updated")
	return item

# 获取指定槽位的物品
func get_item(slot: int) -> InventoryItem:
	if slot < 0 or slot >= size:
		return null
	return slots[slot]

# 查找可堆叠的相同物品
func find_similar_item(item: InventoryItem) -> int:
	for i in range(size):
		var slot_item = slots[i]
		if slot_item and slot_item.id == item.id and slot_item.current_stack < slot_item.stack_size:
			return i
	return -1

# 查找空槽位
func find_empty_slot() -> int:
	for i in range(size):
		if not slots[i]:
			return i
	return -1

# 检查背包是否已满
func is_full() -> bool:
	return find_empty_slot() == -1

# 获取已使用的槽位数量
func get_used_slots() -> int:
	var count = 0
	for item in slots:
		if item:
			count += 1
	return count

# 清空背包
func clear():
	for i in range(size):
		if slots[i]:
			remove_item(i)
	emit_signal("inventory_updated")

# 交换两个槽位的物品
func swap_items(from_slot: int, to_slot: int) -> bool:
	if from_slot < 0 or from_slot >= size or to_slot < 0 or to_slot >= size:
		return false
	
	var temp = slots[to_slot]
	slots[to_slot] = slots[from_slot]
	slots[from_slot] = temp
	
	if slots[to_slot]:
		emit_signal("item_changed", slots[to_slot], to_slot)
	if slots[from_slot]:
		emit_signal("item_changed", slots[from_slot], from_slot)
	
	emit_signal("items_swapped", from_slot, to_slot)
	emit_signal("inventory_updated")
	return true

# 移动物品到新位置
func move_item(from_slot: int, to_slot: int) -> bool:
	if from_slot < 0 or from_slot >= size or to_slot < 0 or to_slot >= size:
		return false
	
	if slots[to_slot] != null:
		return swap_items(from_slot, to_slot)
	
	var item = slots[from_slot]
	if item == null:
		return false
	
	slots[from_slot] = null
	slots[to_slot] = item
	
	emit_signal("item_removed", item, from_slot)
	emit_signal("item_added", item, to_slot)
	emit_signal("inventory_updated")
	return true
