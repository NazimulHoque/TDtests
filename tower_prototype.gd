extends StaticBody3D
var troop = preload("res://Scenes/Player/ally_prototype.tscn")
var troops : Array[Ally]
@onready var troop_holder = $Troops
@export var spawn_position : Node3D
@onready var radius = $Radius
@onready var col_shape = $Radius/Movement_Area/Clickable
var active : bool = false
var selection_action = "Select"
var respawning : bool = false
@onready var respawn_timer = $"Respawn Timer"
@onready var ui = $"Respawn Timer Interface/SubViewport/Radial"

signal movement_done

func _ready():
	ui.visible = false
	radius.visible = false
	spawn_troops()

func _on_selection_area_select_toggled(selection):
	active = selection
	radius.visible = selection

func spawn_troops():
	var troop_0 = troop.instantiate()
	var troop_1 = troop.instantiate()
	var troop_2 = troop.instantiate()
	troop_0.set_name("Troop_0")
	troop_1.set_name("Troop_1")
	troop_2.set_name("Troop_2")
	troop_holder.add_child(troop_0)
	troop_holder.add_child(troop_1)
	troop_holder.add_child(troop_2)
	troop_0.global_transform.origin = spawn_position.global_transform.origin
	troop_0.global_transform.origin.z += 0.5
	troop_1.global_transform.origin = spawn_position.global_transform.origin
	troop_1.global_transform.origin.x += 0.5
	troop_2.global_transform.origin = spawn_position.global_transform.origin
	troops.append(troop_0)
	troops.append(troop_1)
	troops.append(troop_2)


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if active:
		if event.is_action_pressed(selection_action):
			var current_index = 0
			for troop in troops:
				if troop.get_current_target() == null and troop.get_assist_target() == null:
					troop.nav.target_position = position
					if current_index == 0:
						position.z += 0.5
					if current_index == 1:
						position.z -= 0.5
						position.x -= 0.5
					current_index += 1
			active = false
			radius.visible = false
			movement_done.emit()


func move_units(position, speed):
	var  target_pos = position
	var direction = troop_holder.global_position.direction_to(target_pos)
	troop_holder.velocity = direction * speed
	troop_holder.move_and_slide()

func _physics_process(delta):
	if troops.size() < 3:
		respawn_units()
	else:
		ui.visible = false

func respawn_units():
	if not respawning:
		respawn_timer.start()
		respawning = true
#	if respawning:
#		ui.visible = true
#		var progress = (respawn_timer.time_left/respawn_timer.wait_time) * 100
#		ui.set_value(progress)
		
		

func _on_respawn_timer_timeout():
	var new_troop = troop.instantiate()
	troop_holder.add_child(new_troop)
	new_troop.global_transform.origin = spawn_position.global_transform.origin
	troops.append(new_troop)
	if troops.size() == 2:
		new_troop.global_transform.origin.z += 0.5
	if troops.size() == 3:
		new_troop.global_transform.origin.x += 0.5
	respawning = false

#diff way of detecting input, kinda sucks
#func _input(event):
#	if active:
#		if Input.is_action_just_pressed("Select"):
#			var camera = get_tree().get_first_node_in_group("Camera")
#			var position = get_viewport().get_mouse_position()
#			var raylen = 100
#			var from = camera.project_ray_origin(position)
#			var to = camera.project_ray_normal(position) * raylen
#			var space = get_world_3d().direct_space_state
#			var rayQuery = PhysicsRayQueryParameters3D.new()
#			rayQuery.from = from
#			rayQuery.to = to
#			rayQuery.collide_with_areas = true
#			var results = space.intersect_ray(rayQuery)
#			if results["collider"] == testing_something:
#				print ("OOOOOO")
