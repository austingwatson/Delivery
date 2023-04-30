extends CanvasLayer

var current_cargo = null
var selected_slots = []
var direction = 0

onready var selector = $Selector


func _unhandled_input(event):
	if event.is_action_pressed("rotate"):
		direction += 1
		if direction == 4:
			direction = 0


func _physics_process(delta):
	if visible:
		selector.position = selector.get_global_mouse_position()


func open_inventory(change_timescale):
	if change_timescale:
		Engine.time_scale = 0.1
	visible = true
	Entities.cart.input_blocked = true
	

func set_current_cargo(cargo):
	pass
		
	
func close_inventory():
	if selected_slots.size() == current_cargo.inventory_size.x * current_cargo.inventory_size.y:
		for selected_slot in selected_slots:
			selected_slot.has_room = false
	else:
		print("no room")
	
	current_cargo.get_parent().remove_child(current_cargo)
	add_child(current_cargo)
	current_cargo.disable()
	calculate_midpoint()
	Engine.time_scale = 1.0
	#visible = false
	Entities.cart.input_blocked = false
	current_cargo = null
	selected_slots.clear()


func calculate_midpoint():
	var midpoint = Vector2.ZERO
	for selected_slot in selected_slots:
		midpoint += selected_slot.global_position
	midpoint /= selected_slots.size()
	current_cargo.global_position = midpoint


func _on_Selector_area_entered(area):
	if area.has_room:
		selected_slots.append(area)


func _on_Selector_area_exited(area):
	if area.has_room:
		selected_slots.erase(area)
