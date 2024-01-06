extends GridMap

var ray_origin = Vector3()
var ray_target = Vector3()
var floor = 0
var tower_sel = false
var tower_type = 0
var selected_tower
var gridposition
var grid_pos_transform  
var TowersceneT1 = preload("res://Scenes/Towers/tower.tscn")
var newtower

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos_on_map()

func _physics_process(delta):
	pass

	


func mouse_pos_on_map():
	var mouse_position = get_viewport().get_mouse_position()
	
	#print(mouse_position)
	#move_ui_to_place(mouse_position)
	ray_origin = $"../Camera3D".project_ray_origin(mouse_position)
	ray_target = ray_origin + $"../Camera3D".project_ray_normal(mouse_position) * 2000
	#print(ray_origin, ray_target)
	var space_state = get_world_3d().direct_space_state
	#PhysicsRayQueryParameters3D is required to create parameters for space state in godot 4
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target)
	var intersection = space_state.intersect_ray(query)
	#for now we need a cgbox in the scene tree to register this, but we will bake this into
	#the meshlibrary later
	if not intersection.is_empty():
		var pos = intersection.position
		#print(pos)
		var look_at_me = Vector3(pos.x, floor, pos.z)
		var loc_vec = to_local(look_at_me)
		#print(loc_vec)
		var map_pos = local_to_map(loc_vec)
		#print("map pos", map_pos)
		#set_cell_item(local_pos, 52, 0)
		var local_pos = map_to_local(map_pos)
		#print("local pos",local_pos )
		#must convert to global postion space for accurate postion relative to screen 
		#print("global pos",to_global(local_pos))
		#print(local_pos, map_pos, loc_vec)
		var screen_pos = $"../Camera3D".unproject_position(to_global(local_pos))
		#print("camera space from mouse", screen_pos)
		#$Label.set_position(screen_pos)
		#print(look_at_me)
		gridposition = to_global(local_pos)
		print(gridposition)
		grid_pos_transform= Transform3D(Basis.from_scale(Vector3(0.5,0.5,0.5)), gridposition)
		if newtower != null:
			newtower.set_global_transform(grid_pos_transform)
		
		





func move_ui_to_place(mousepos):
	pass


func _on_control_newtower_selected(tower_t, towersel):
	print(tower_t, towersel)
	tower_type = tower_t
	tower_sel = towersel
	show_newTower_UI()

	


func show_newTower_UI():
	#instantiates a new tower scene to act as a preview for tower placement 
	if tower_sel and newtower == null:
		if tower_type == 1:
			newtower = TowersceneT1.instantiate()
			
		if tower_type == 2:
			newtower = TowersceneT1.instantiate()
			
		
		add_child(newtower)
		
	if !tower_sel:
		if newtower != null:
			newtower.queue_free()
		
		
		

