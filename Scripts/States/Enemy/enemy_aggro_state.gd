class_name Enemy_Aggro_State
extends State

signal no_units_detected

@export var actor: Enemy
@export var attack_timer : Timer

var target_ally : Ally
var distance 
var attack_power

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	if is_instance_valid(actor.get_target_ally()):
		target_ally = actor.get_target_ally()
		attack_power = actor.attack_power
		attack_timer.start()
		set_physics_process(true)
		
		
func _physics_process(_delta):
	if not is_instance_valid(target_ally):
		actor.detected_ally.erase(target_ally)
		no_units_detected.emit()
	if not target_ally:
		attack_timer.stop()
		no_units_detected.emit()
		
func _exit_state() -> void:
	set_physics_process(false)




func _on_attack_timer_timeout():
	if is_instance_valid(target_ally):
		target_ally.take_damage(attack_power)
	else:
		return
