extends Control

@export var curr_label : Label
@export var health_label : Label


func update_currency(amount):
	var new_text = "Currency: " + str(amount)
	curr_label.text = new_text
	
func update_health(amount):
	var new_text = "HP: " + str(amount)
	health_label.text = new_text
