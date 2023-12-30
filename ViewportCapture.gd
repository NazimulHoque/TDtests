extends Node3D

var img

# Called when the node enters the scene tree for the first time.
func _ready():
	await RenderingServer.frame_post_draw
	$SubViewportContainer/SubViewport.get_texture().get_image().save_png("tower_thumb_noBG.png")
	
func _process(delta):
	pass

	
	
	
	
	
	


