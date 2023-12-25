#class_name WaveData
#extends Node3D
#var enemy_type: String
#var quantity: int
#var wave_cooldown: float
#
#func _init(enemy_type, quantity, wave_cooldown):
#	self.enemy_type = enemy_type
#	self.quantity = quantity
#	self.wave_cooldown = wave_cooldown


class_name WaveData
extends Resource
@export var enemies: Array[PackedScene]
@export var wave_cooldown: float
