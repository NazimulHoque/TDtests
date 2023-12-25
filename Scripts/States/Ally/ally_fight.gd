class_name Ally_Fighting
extends State

@export var actor : Ally
@export var attack_timer : Timer

var current_target : Enemy
var attack_power

signal fight_ended

func _enter_state() -> void:
	if is_instance_valid(actor.get_current_target()):
		current_target = actor.get_current_target()
		attack_power = actor.attack_power
		attack_timer.start(0.5)
		set_physics_process(true)
	if not actor.get_current_target():
		fight_ended.emit()
	
func _physics_process(_delta):
	if not current_target:
		attack_timer.stop()
		fight_ended.emit()
	if not is_instance_valid(current_target):
		fight_ended.emit()

func _exit_state() -> void:
	set_physics_process(false)
	




func _on_attack_timer_timeout():
	if is_instance_valid(current_target):
		print("ATTACK")
		current_target.take_damage(attack_power)
	else:
		return


func _on_enemy_detection_body_exited(body):
	if body is Enemy:
		actor.detected_enemies.erase(body)
