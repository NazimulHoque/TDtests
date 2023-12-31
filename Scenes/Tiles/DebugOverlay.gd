extends CanvasLayer

@onready var draw = $DebugDraw3D



# Called when the node enters the scene tree for the first time.
func _ready():
	if not InputMap.has_action("toggle_debug"):
		InputMap.add_action("toggle_debug")
		var ev = InputEventKey.new()
		ev.scancode = KEY_BACKSLASH
		InputMap.action_add_event("toggle_debug", ev)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _input(event):
	if event.is_action_pressed("toggle_debug"):
		for n in get_children():
			n.visible = not n.visible
