extends Node3D

var look_target = Vector3()

var cannonball = preload("res://Scenes/Towers/cannon_ball.tscn")


@export var muzzle_speed = 30
@export var millis_between_shots = 1000.00
@export var damage = 100
@export var enemies = []
@onready var rof_timer = $Turret/Timer
var can_shoot = true
var shooting = false
var placement_state = false


func _ready():
	rof_timer.wait_time = millis_between_shots/1000.00
	#hide invalid turret objects on start up, invalid objects are only for ui
	$invalid_Turret2.hide()
	$invalid_TowerBase2.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	detect_enemies()
	turn_tower()
	check_enemies()
	shoot()
	

	
func check_enemies():
	if not enemies.is_empty():
		for enemy in enemies:
			if not is_instance_valid(enemy):
				enemies.erase(enemy)

func set_look_target(target):
	look_target = target
	
func get_height():
	return get_node("Height").position.y
	
func turn_tower():
	if look_target:
		get_node("Turret").look_at(look_target)
	#compute angle between mouse vector and 

func shoot():
	if can_shoot:
		#print("shooting")
		if not enemies.is_empty():
			spawn_bullet()
			enemies[0].take_damage(damage)
			#print("enemy taking damage")
		rof_timer.start()
		can_shoot = false
		



func spawn_bullet():
		var new_cball = cannonball.instantiate()
		new_cball.global_transform = $Turret/muzzle.global_transform
		new_cball.speed = muzzle_speed
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_cball)
	

func _on_timer_timeout():
	can_shoot = true
	


func set_invalid_state(invalid_state : bool):
	#optimization possible, check whetehre valid_state has changes so that 
	#you arent constantly changing the scene 
	if invalid_state:
		placement_state = false
		$Turret.hide()
		$TowerBase.hide()
		$invalid_Turret2.show()
		$invalid_TowerBase2.show()
	else:
		placement_state = true
		$Turret.show()
		$TowerBase.show()
		$invalid_Turret2.hide()
		$invalid_TowerBase2.hide()
		
	
	
func can_place():
	return placement_state
	
func set_default_mat():
	#set the material for the default looking tower
	pass


func detect_enemies():
	
	if $Area3D.has_overlapping_bodies():
		#print("enemy detected")
		enemies = $Area3D.get_overlapping_bodies()
		print(enemies)
		look_target = enemies[0].global_position
	else:
		#Sprint("not detected")
		enemies = []


func _on_detection_area_3d_body_entered(body):
	pass


func _look_at_target_interpolated(weight:float):
	#var xform := transform # your transform
	#xform = xform.looking_at(look_target.global_position,Vector3.UP)
	#transform = transform.interpolate_with(xform,weight)
	pass
	



func _on_selection_area_select_toggled(selection):
	#onclick do soemthing 
	pass # Replace with function body.
