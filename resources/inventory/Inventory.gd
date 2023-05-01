class_name Inventory
extends Resource

export var wagon_items = []
export var front_items = []


func add_next_slot(new_item) -> Array:
	var found = 0
	for i in wagon_items.size():
		found = 0
		for j in wagon_items[i].size():
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
					
				result.push_front(wagon_items[i].size())
				result.push_front(i)
				return result
	
	if front_items[0] == null:
		front_items[0] = new_item
		return [1, 16, 0]
	elif front_items[1] == null:
		front_items[1] = new_item
		return [1, 16, 1]
	
	return []
	
