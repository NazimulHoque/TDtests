extends Node3D
#script for controlling what type of projectile gets assinged to towers
@export var speed = 10

func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(forward_dir * speed * delta)

