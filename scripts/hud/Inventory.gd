extends CanvasLayer

var current_cargo = null
var selected_slots = []
var direction = 0

onready var selector = $Selector
onready var selector_shape = $Selector/CollisionShape2D


func _unhandled_input(event):
	if event.is_action_pressed("rotate"):
		direction += 1
		if direction == 4:
			direction = 0


func _physics_process(_delta):
	if visible:
		selector.position = selector.get_global_mouse_position()
		


func open_inventory(change_timescale):
	if change_timescale:
		Engine.time_scale = 0.1
	visible = true
	Entities.cart.input_blocked = true
	
	selector_shape.set_deferred("disabled", false)
	selector_shape.shape.extents = Vector2(3 * current_cargo.inventory_size.x, 3 * current_cargo.inventory_size.y)
		
	
func close_inventory():
	if selected_slots.size() == current_cargo.inventory_size.x * current_cargo.inventory_size.y:
		for selected_slot in selected_slots:
			selected_slot.give_item(null, null, null)
		selected_slots[0].give_item(current_cargo.icon, selected_slots, 0)
	else:
		print("no room")
	
	Engine.time_scale = 1.0
	visible = false
	Entities.cart.input_blocked = false
	#current_cargo.disable()
	current_cargo = null
	selected_slots.clear()
	selector_shape.set_deferred("disabled", true)


func set_selection():
	var selection_amount = 0
	for selected_slot in selected_slots:
		if selected_slot.index <= 15:
			selection_amount += 1
	
	if selection_amount == current_cargo.inventory_size.x * current_cargo.inventory_size.y:
		for selected_slot in selected_slots:
			selected_slot.set_yes()
	else:
		for selected_slot in selected_slots:
			selected_slot.set_no()

func _on_Selector_area_entered(area):
	if area.has_room:
		selected_slots.append(area)
		
		set_selection()


func _on_Selector_area_exited(area):
	if area.has_room:
		for selected_spot in selected_slots:
			selected_spot.set_clear()
		selected_slots.erase(area)
		set_selection()


func _on_MouseHover_area_entered(area):
	if current_cargo != null:
		current_cargo.get_parent().remove_child(current_cargo)
		call_deferred("add_child", current_cargo)
		#current_cargo.global_position = selector.global_position


func _on_MouseHover_area_exited(area):
	if current_cargo != null:
		remove_child(current_cargo)
		Entities.call_deferred("add_child", current_cargo)
