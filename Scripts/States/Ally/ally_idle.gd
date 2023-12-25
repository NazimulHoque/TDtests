class_name Ally_Idle
extends State

@export var actor : Ally
@export var assist_timer : Timer

var close_enough : bool = false
var assisting : bool = false
var outside : bool = false
var current_target : Enemy = null
var assist_target : Enemy = null
var desired_distance = 1

signal fight_started

func _enter_state() -> void:
	set_physics_process(true)
	
func _physics_process(delta):
	if (actor.parent_tower.radius.global_position - actor.global_position).length() > 9.5:
		outside = true
	if not current_target and not assist_target and outside:
		back_to_radius(delta)
	if not current_target:
		cycle_enemies()
	else:
		assist_target = null
		if is_instance_valid(current_target):
			actor.current_target = current_target
			engage_to_attack(current_target, delta)
	if assist_target and not current_target:
		if is_instance_valid(assist_target):
			actor.assist_target = assist_target
			check_distance(assist_target, delta)
			if not close_enough:
				engage_to_assist(assist_target, delta)	
			else:
				actor.nav.target_position = actor.global_position
				if not assisting:
					assist_timer.start()
					assisting = true

func engage_to_attack(target : Enemy, _delta):
	actor.nav.target_position = current_target.global_position
	var target_vector = target.global_position - actor.global_position
	var distance = target_vector.length()
	if distance < desired_distance:
		fight_started.emit()

func cycle_enemies():
	if actor.detected_enemies.size() > 0:
		for enemy in actor.detected_enemies: #for every enemy in the array, check
			if not current_target:
				if enemy not in actor.enemy_manager.marked_enemies:
					current_target = enemy
					actor.enemy_manager.marked_enemies.append(enemy)
					break
		if not current_target and not assist_target:
			assist_target = get_nearest_enemy()

func get_nearest_enemy():
	var closest_enemy = null
	var min_distance = INF
	for enemy in actor.detected_enemies:
		var distance = actor.position.distance_to(enemy.position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy
	return closest_enemy
	
func close_distance(pos_target : Enemy, _distance, delta):
	var direction = Vector3()
	var target_position = pos_target.global_position
	direction = target_position - actor.global_position
	direction = direction.normalized()
	actor.velocity = actor.velocity.lerp(direction * actor.speed , actor.accel * delta)
	actor.move_and_slide()
	
func check_distance(target : Enemy, _delta):
	var target_vector = target.global_position - actor.global_position
	var distance = target_vector.length()
	if distance > desired_distance:
		close_enough = false
	else:
		close_enough = true
		
func engage_to_assist(ass_target : Enemy, _delta):
	actor.nav.target_position = ass_target.global_position

func avoid_collision(_delta):
	for ally in actor.detected_ally:
		if ally != actor:
			var distance_to_ally = actor.global_position.distance_to(ally.global_position)
			var min_distance = 0.5
			if distance_to_ally < min_distance:
				var collision_distance = 0.5
				if actor.global_position.z <= ally.global_position.z:
					actor.velocity.z -= collision_distance
					actor.move_and_slide()
				else:
					actor.velocity.z += collision_distance
					actor.move_and_slide()

func avoid_stacking(delta):
	for enemy in actor.detected_enemies:
		var distance = actor.position.distance_to(enemy.position)
		if distance < 40:
			var direction = (actor.position - enemy.position).normalized()
			var avoidance_velocity = direction * (10 - distance)
			actor.velocity = actor.velocity.lerp(avoidance_velocity * actor.speed , actor.accel * delta)

func back_to_radius(_delta):
	if (actor.parent_tower.radius.global_position - actor.global_position).length() > 10.2:
		actor.nav.target_position = actor.parent_tower.radius.global_position
	else:
		actor.nav.target_position = actor.global_position
		outside = false
func _on_ally_detection_body_entered(body):
	if body is Ally:
		actor.detected_ally.append(body)
func _on_ally_detection_body_exited(body):
	if body is Ally:
		actor.detected_ally.erase(body)
func _on_enemy_detection_body_entered(body):
	if body is Enemy:
		actor.detected_enemies.append(body)
func _on_enemy_detection_body_exited(body):
	if body is Enemy:
		actor.detected_enemies.erase(body)
func _exit_state() -> void:
	set_physics_process(false)


func _on_assist_timer_timeout():
	print("ASSISTING")
	if assist_target:
		if is_instance_valid(actor.assist_target):
			assist_target.take_damage(actor.attack_power)
			assisting = false
		else:
			actor.assist_target = null
			close_enough = false
			assisting = false
			assist_timer.stop()
