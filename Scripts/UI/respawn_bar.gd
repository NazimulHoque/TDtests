extends Control

func _ready():
	hide()

func set_value(value):
	$TextureProgressBar.value = value
	if value > 0:
		show()
	else:
		hide()
