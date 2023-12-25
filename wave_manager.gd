extends Node3D

var marked_enemies = []

@export var spawner : Node3D
@export var level_paths : Array[Path3D]
@export var waves : Array[WaveData]
var level_path : Path3D
@onready var spawn_timer = $SpawnTimer
var wave_in_progress
var rng = RandomNumberGenerator.new() #rng the path
var current_wave = 0 #current wave index
var time_since_last_wave = 0
var spawn_position
@export var hud : Control
@export var starting_currency : int
var current_currency : int
@export var starting_health : int
var current_health : int

func _ready():
	spawn_position = spawner.position
	current_currency = starting_currency
	current_health = starting_health
	hud.update_currency(current_currency)
	hud.update_health(current_health)
	
func _physics_process(delta):
	rng.randomize()
	if current_wave < len(waves):
		if time_since_last_wave >= waves[current_wave].wave_cooldown:
			spawn_wave()
			time_since_last_wave = 0
		else:
			time_since_last_wave += delta
	else:
		pass

func spawn_wave():
	var wave_data = waves[current_wave]
	current_wave += 1
	for enemy_scene in wave_data.enemies:
		level_path = level_paths[rng.randi_range(0, (len(level_paths) - 1))]
		var enemy_instance = enemy_scene.instantiate()
		level_path.add_child(enemy_instance)
		enemy_instance.position = spawn_position
		spawn_timer.start()
		await spawn_timer.timeout
		spawn_timer.stop()
	time_since_last_wave = 0

func update_currency(amount, is_adding : bool):
	if is_adding:
		current_currency += amount
	else:
		current_currency -= amount
	hud.update_currency(current_currency)
	
func update_health(amount, is_damage : bool):
	if is_damage: 
		current_health -= amount
	else:
		current_health += amount
	hud.update_health(current_health)
	
