class_name Inventory
extends Resource

signal item_changed(side, i, j, full)

export var wagon_items = []
export var front_items = []
export var current_size = Vector2.ZERO


func remove_wagon_item(i, j):
	wagon_items[i][j] = null
	emit_signal("item_changed", 0, i, j, false)
	

func remove_front_item(i):
	front_items[i] = null
	emit_signal("item_changed", 1, i, 0, false)


func add_next_slot(new_item) -> Array:
	if new_item.get_type() == 1:
		var front = look_front_first(new_item)
		if front != null:
			return front
	
	var found = 0
	for i in wagon_items.size() - (wagon_items.size() - current_size.x):
		found = 0
		for j in wagon_items[i].size() - (wagon_items[i].size() - current_size.y):
			if wagon_items[i][j] == null:
				found += 1
			else:
				found = 0
			
			if found == new_item.get_size():
				var result = []
				for k in range(j, j - found, -1):
					result.push_front(k)
					
				for k in result:
					wagon_items[i][k] = new_item
					emit_signal("item_changed", 0, i, k, true)
					
				result.push_front(wagon_items[i].size())
				result.push_front(i)
				return result
	
	if front_items[0] == null:
		front_items[0] = new_item
		emit_signal("item_changed", 1, 0, 0, true)
		return [1, 16, 0]
	elif front_items[1] == null:
		front_items[1] = new_item
		emit_signal("item_changed", 1, 1, 0, true)
		return [1, 16, 1]
	
	return []
	

func look_front_first(new_item):
	if front_items[0] == null:
		front_items[0] = new_item
		emit_signal("item_changed", 1, 0, 0, true)
		return [1, 16, 0]
	elif front_items[1] == null:
		front_items[1] = new_item
		emit_signal("item_changed", 1, 1, 0, true)
		return [1, 16, 1]
	
	return null
