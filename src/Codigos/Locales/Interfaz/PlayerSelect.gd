extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var inicia = "inicio player select"
var personaje = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	print (inicia)
	pass # Replace with function body.


# Clled every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	print (inicia, personaje, "selected")
	pass # Replace with function body.


func _on_PersonajeA_pressed():
	personaje = " Mario "
	pass # Replace with function body.


func _on_PersonajeA2_pressed():
	personaje = " Luigi "
	pass # Replace with function body.


func _on_PersonajeA3_pressed():
	personaje = " Peach "
	pass # Replace with function body.


func _on_PersonajeA4_pressed():
	personaje = " Toad "
	pass # Replace with function body.


func _on_PersonajeA5_pressed():
	personaje = " Yoshi "
	pass # Replace with function body.


func _on_PersonajeA6_pressed():
	personaje = " D.K. "
	pass # Replace with function body.


func _on_PersonajeA7_pressed():
	personaje = " Wario "
	pass # Replace with function body.


func _on_PersonajeA8_pressed():
	personaje = " Bowser "
	pass # Replace with function body.
