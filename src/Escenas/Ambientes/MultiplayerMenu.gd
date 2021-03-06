extends MarginContainer

const SCENE_NAMES = preload("res://Escenas/Ambientes/ScenePaths.gd");
var multiplayer_gd = preload('res://Codigos/Locales/Interfaz/Contenedor_camaras.gd')
onready var levelChanger = get_child(0);

var current_selection = 0

#const first_scene = preload("res://escenas/mundo1.tscn")

onready var selector_one = $VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer2/Selector
onready var selector_two = $VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer2/Selector
onready var selector_three = $VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer5/HBoxContainer2/Selector
onready var selector_four = $VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer2/Selector


func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
	selector_four.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
	elif _current_selection == 2:
		selector_three.text = ">"
	elif _current_selection == 3:
		selector_four.text = ">"

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 3:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)
		
	
func handle_selection(_current_selection):
	if _current_selection == 0:
		#get_parent().add_child(first_scene.instance())
		levelChanger.requestLevelChange(SCENE_NAMES.SCENE_PATHS.SCENE_MULTIPLAYER1);
		Senales.emit_signal("elige_multiplayer", 1)
		get_tree().change_scene("res://Escenas/Ambientes/Pista_prueba.tscn")
		queue_free()
		#get_tree().change_scene("res://escenas/Intro.tscn")
		
	elif _current_selection == 1:
		levelChanger.requestLevelChange(SCENE_NAMES.SCENE_PATHS.SCENE_MULTIPLAYER2);
		Senales.emit_signal("elige_multiplayer", 2)	
		get_tree().change_scene("res://Escenas/Ambientes/Pista_prueba.tscn")
		queue_free()
		#get_tree().change_scene("res://escenas/AcercaDe.tscn")
		#queue_free()
	elif _current_selection == 2:
		levelChanger.requestLevelChange(SCENE_NAMES.SCENE_PATHS.SCENE_MULTIPLAYER3);
	elif _current_selection == 3:
		levelChanger.requestLevelChange(SCENE_NAMES.SCENE_PATHS.SCENE_MULTIPLAYER4);

func _ready():
	set_current_selection(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
