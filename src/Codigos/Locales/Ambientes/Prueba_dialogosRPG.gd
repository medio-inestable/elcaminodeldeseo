extends Node2D

var dialogic_d = Dialogic.start('timeline-prueba')

func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_Q:
			add_child(dialogic_d)

