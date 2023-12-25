extends Enemy
@export var enemy_data = Enemy_Data.new()
@export var detected_ally : Array[Ally]
var target_Ally : Ally

var health
var speed
var attack_power
var accel
var currency_drop
var hp_loss

var lvl_manager
@onready var parent = $".."
signal die

@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_patrol_state = $FiniteStateMachine/Enemy_Patrol_State as Enemy_Patrol_State
@onready var enemy_aggro_state = $FiniteStateMachine/Enemy_Aggro_State as Enemy_Aggro_State

func _ready():
	health = enemy_data.health
	speed = enemy_data.speed
	attack_power = enemy_data.attack_power
	currency_drop = enemy_data.currency_drop
	hp_loss = enemy_data.hp_loss
	
	lvl_manager = get_tree().get_first_node_in_group("Manager")
	enemy_patrol_state.ally_detected.connect(fsm.change_state.bind(enemy_aggro_state))
	enemy_aggro_state.no_units_detected.connect(fsm.change_state.bind(enemy_patrol_state))


func _physics_process(_delta):
	if health <= 0:
		lvl_manager.update_currency(currency_drop, true)
		death()

func set_target_ally(new_ally : Ally):
	if new_ally is Ally:
		target_Ally = new_ally

func remove_target_ally():
	target_Ally = null
	
func get_target_ally() -> Ally:
	return target_Ally
	
func take_damage(damage : float):
	health = health - damage
	
func death():
	parent.queue_free()
