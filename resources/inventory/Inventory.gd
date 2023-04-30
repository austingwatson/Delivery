class_name Inventory
extends Resource

export var wagon_items = []
export var front_items = []


func add_next_slot(new_item) -> Array:
	var found = 0
	for i in wagon_items.size():
		if wagon_items[i] == null:
			found += 1
		else:
			found = 0
		
		if found == new_item.get_size():
			var result = []
			for j in range(i, i - found, -1):
				result.push_front(j)
				
			for j in result:
				wagon_items[j] = new_item
			return result
	
	return []
	
