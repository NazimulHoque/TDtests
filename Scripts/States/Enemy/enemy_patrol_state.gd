class_name  Enemy_Patrol_State
extends State

@export var actor: Enemy
var current_ally
@onready var path_follow = $"../../.."

signal ally_detected

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	current_ally = null
	set_physics_process(true)
func _physics_process(delta):
	cycle_allies()
	move(delta)
	if current_ally:
		actor.set_target_ally(current_ally)
		ally_detected.emit()


func _exit_state() -> void:
	set_physics_process(false)


func _on_area_3d_body_entered(body):
	if body is Ally:
		actor.detected_ally.append(body)


func _on_area_3d_body_exited(body):
	if body is Ally:
		actor.detected_ally.erase(body)
	
func cycle_allies():
	for ally in actor.detected_ally:
		if is_instance_valid(ally):
			if ally.get_current_target() == actor:
				if not current_ally:
					current_ally = ally

func move(delta):
	path_follow.progress += actor.speed * delta
	if path_follow.progress_ratio >= 1:
		actor.lvl_manager.update_health(actor.hp_loss, true)
		actor.queue_free()
	
