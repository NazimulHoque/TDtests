extends Ally
@export var ally_data = Ally_Data.new()
@export var detected_ally : Array [Ally]
@export var detected_enemies : Array[Enemy]
@export var current_target : Enemy = null
@export var assist_target : Enemy = null
@export var nav : NavigationAgent3D

var parent_tower
var enemy_manager
var health
var speed
var attack_power
var accel = 7


@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var ally_fighting = $FiniteStateMachine/Ally_Fighting as Ally_Fighting
@onready var ally_idle = $FiniteStateMachine/Ally_Idle as Ally_Idle



signal dead_ally(ally: Ally)

func _ready():
	health = ally_data.health
	speed = ally_data.speed
	attack_power = ally_data.attack_power
	enemy_manager = get_tree().current_scene.get_node("WaveManager")
	ally_idle.fight_started.connect(fsm.change_state.bind(ally_fighting))
	ally_fighting.fight_ended.connect(fsm.change_state.bind(ally_idle))
	parent_tower = get_parent().get_parent()
	
func _physics_process(delta):
	if health <= 0:
		death()
	move_to_point(delta)

	
func get_current_target():
	return current_target

func set_current_target(new_target : Enemy):
	current_target = new_target
	
func get_assist_target():
	return assist_target

func set_assist_target(new_target : Enemy):
	assist_target = new_target

func take_damage(damage : float):
	health = health - damage

func death():
	if current_target:
		if current_target in enemy_manager.marked_enemies:
			enemy_manager.marked_enemies.erase(current_target)
			dead_ally.emit(self)
	parent_tower.troops.erase(self)
	queue_free()


func _on_selection_area_select_toggled(_selection):
	print("PRESSED!")
	
func move_to_point(delta):
	var rotation_speed_factor = 10
	var target_position = nav.get_next_path_position()
	var dir= global_position.direction_to(target_position)
	var direction = dir.normalized()
	if global_transform.origin.is_equal_approx(target_position):
		return
	else:
		var interp_pos = global_transform.origin.lerp(target_position, delta * rotation_speed_factor)
		interp_pos.y = global_transform.origin.y
		if global_transform.origin.is_equal_approx(interp_pos):
			return
		else:
			look_at(interp_pos, Vector3.UP)
	var distance_to_next_position = global_position.distance_to(target_position)
	if distance_to_next_position < 0.5:
		return
	else:
		velocity = direction * speed
		move_and_slide()
