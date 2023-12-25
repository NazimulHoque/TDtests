extends Control
var player 
var camera
var width = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../GridMap")
	camera = get_node("../../Camera3D")
	


func _draw():
	var color = Color(0, 1, 0)
	var start = camera.unproject_position(player.ray_origin)
	var end = camera.unproject_position(player.ray_target)
	draw_line(start, end, color, width)
	draw_triangle(end, start.direction_to(end), width*2, color)

func draw_triangle(pos, dir, size, color):
	var a = pos + dir * size
	var b = pos + dir.rotated(2*PI/3) * size
	var c = pos + dir.rotated(4*PI/3) * size
	var points = PackedVector2Array([a, b, c])
	draw_polygon(points, PackedColorArray([color]))
