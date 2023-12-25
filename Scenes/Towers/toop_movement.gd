extends CharacterBody3D
@onready var nav = $NavigationAgent3D
var speed = 10
func _physics_process(delta):
	if nav.is_navigation_finished():
		return
	move_to_point(delta, 10)
	pass
	
func move_to_point(delta, speed):
	var target_pos = nav.get_next_path_position()
	var direction = global_position.direction_to(target_pos)
	velocity = direction * speed
	print("TEST")
	move_and_slide()

func _on_tower_prototype_valid_spot(position):
	nav.target_position = position
