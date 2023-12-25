extends Node3D

@export var spawner : Node3D
@export var level_paths : Array[Path3D]
@export var waves : Array[WaveData]
var level_path : Path3D
@onready var spawn_timer = $SpawnTimer

var rng = RandomNumberGenerator.new() #rng the path
var current_wave = 0 #current wave index
var time_since_last_wave = 0
var spawn_position

func _ready():
	spawn_position = spawner.position
	
	
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
	
	for enemy_scene in wave_data.enemies:
		level_path = level_paths[rng.randi_range(0, (len(level_paths) - 1))]
		var enemy_instance = enemy_scene.instantiate()
		level_path.add_child(enemy_instance)
		enemy_instance.position = spawn_position
		spawn_timer.start()
		await spawn_timer.timeout
		spawn_timer.stop()
	current_wave += 1
	time_since_last_wave = 0
