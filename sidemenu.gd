extends Control

var towerselectable = false
var tower_type = 0;

signal newtower_selected(tower_type, towerselectable)




# Called when the node enters the scene tree for the first time.
func _ready():
	$sidemenu.hide()
	$areaoutside.hide()

func _on_sidebutton_pressed():
	$sidebutton.hide()
	$sidemenu.show()
	$areaoutside.show()

func _on_areaoutside_pressed():
	$sidemenu.hide()
	$sidebutton.show()
	#need area outside button to detect clicks outside side menu, 
	#there is prob a better way to do this
	$areaoutside.hide()
	newtower_selected.emit(0, false)





func _on_t_1_basic_button_pressed():
	print("t1 basic press")
	towerselectable = true
	tower_type = 1
	newtower_selected.emit(tower_type, towerselectable)


func _on_t_1_tesla_button_pressed():
	print("t1 tesla press")
	towerselectable = true
	tower_type = 2
	newtower_selected.emit(tower_type, towerselectable)
