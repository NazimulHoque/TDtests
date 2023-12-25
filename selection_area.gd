extends Area3D

signal select_toggled(selection)

var exclusive = true
var selection_action = "Select"
var selected = false : set = set_selected


func set_selected(selection):
	if selection:
		_make_exclusive()
		add_to_group("selected")
	else:
		remove_from_group("selected")
	selected = selection
	emit_signal("select_toggled", selected)
	
func _make_exclusive():
	if not exclusive:
		return
	get_tree().call_group("selected", "set_selected", false)
	
func _input_event(camera, event, position, normal, _shape_idx):
	if event.is_action_pressed(selection_action):
		set_selected(not selected)


func _on_tower_prototype_movement_done():
	set_selected(false)
