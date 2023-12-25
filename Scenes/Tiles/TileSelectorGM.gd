extends GridMap

var ray_origin = Vector3()
var ray_target = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	mouse_pos_on_map()
	


func mouse_pos_on_map():
	var mouse_position = get_viewport().get_mouse_position()
	#print(mouse_position)
	
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
		var look_at_me = Vector3(pos.x, 0, pos.z)
		var loc_vec = to_local(look_at_me)
		#print(loc_vec)
		var local_pos = local_to_map(loc_vec)
		#print(local_pos)
		set_cell_item(local_pos, 36, 0)
		#print(look_at_me)
		
		



