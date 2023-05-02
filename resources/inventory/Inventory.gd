class_name Inventory
extends Resource

signal item_changed(side, i, j, full)

export var wagon_items = []
export var front_items = []
export var current_size = Vector2.ZERO

var current_oxen = 1
var has_speed_boost = false
var front_unlocked = false


func restart():
	for i in wagon_items.size():
		for j in wagon_items[i].size():
			wagon_items[i][j] = null
	front_items[0] = null
	front_items[1] = null
	
	current_oxen = 1
	has_speed_boost = false
	front_unlocked = false


func remove_wagon_item(i, j):
	if wagon_items[i][j] == null:
		return
	
	if wagon_items[i][j].get_type() == 1:
		Entities.cart.remove_archer(0, i, j)
	
	wagon_items[i][j] = null
	emit_signal("item_changed", 0, i, j, false)
	

func remove_front_item(i):
	if front_items[i] == null:
		return
	
	if front_items[i].get_type() == 1:
		Entities.cart.remove_archer(1, i, 0)
	
	front_items[i] = null
	emit_signal("item_changed", 1, i, 0, false)


func drop_random_item():
	var item = remove_next_wagon_item()
		
	if item == null:
		item = next_front_item()
		
	if item == null:
		ToolTip.reduce_health()
	
	return item
	

func remove_next_wagon_item():
	var item = null
	for i in wagon_items.size():
		for j in wagon_items[i].size():
			if wagon_items[i][j] != null:
				if wagon_items[i][j].get_type() == 1:
					continue
				
				item = wagon_items[i][j]
				break
	
	if item != null:
		for i in wagon_items.size():
			for j in wagon_items[i].size():
				if wagon_items[i][j] == item:
					remove_wagon_item(i, j)
	return item
	

func next_front_item():
	if front_items[0] != null:
		if front_items[0].get_type() != 1:
			var item = front_items[0]
			remove_front_item(0)
			return item
	elif front_items[1] != null:
		if front_items[1].get_type() != 1:
			var item = front_items[1]
			remove_front_item(1)
			return item
	

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
	elif front_unlocked and front_items[1] == null:
		front_items[1] = new_item
		emit_signal("item_changed", 1, 1, 0, true)
		return [1, 16, 1]
	
	return []
	

func look_front_first(new_item):
	if front_items[0] == null:
		front_items[0] = new_item
		emit_signal("item_changed", 1, 0, 0, true)
		return [1, 16, 0]
	elif front_unlocked and front_items[1] == null:
		front_items[1] = new_item
		emit_signal("item_changed", 1, 1, 0, true)
		return [1, 16, 1]
	
	return null
