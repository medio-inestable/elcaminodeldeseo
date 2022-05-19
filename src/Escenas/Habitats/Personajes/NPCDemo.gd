extends KinematicBody2D

enum {
	IDLE,
	NEW_DIRECTION,
	MOVE
}

export var walkspeed = 2.0
export (Array, String) var dialogs
const TILESIZE = 16

onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")

var initialposition = Vector2(0,0)
var inputdirection = Vector2(0,0)
var moving = false
var percentmovedtonexttile = 0.0
var state = MOVE
var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN, Vector2.UP]
var direction = Vector2.ZERO

var dialogo

func _ready():
	randomize()
	dialogo =  Dialogic.start(_revuelve(dialogs))
	dialogo.connect("dialogic_signal", self, "dialog_listener")	
	initialposition = position
	
func _process(delta):
	if moving == false:
		process_player_input()
	elif inputdirection != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		moving = false
		
func process_player_input():	
	match state:
		IDLE:
			direction = Vector2.ZERO
			inputdirection = direction
		NEW_DIRECTION:
			direction = directions[_revuelve([0,1,2,3])]
		MOVE:			
			inputdirection = direction
	
	if inputdirection != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", inputdirection)
		anim_tree.set("parameters/Walk/blend_position", inputdirection)
		initialposition = position
		moving = true
	else:
		anim_state.travel("Idle")
		
func move(delta):
	percentmovedtonexttile += walkspeed * delta
	if percentmovedtonexttile >= 1.0:
		position = initialposition + (TILESIZE * inputdirection)
		percentmovedtonexttile = 0.0
		moving = false
	else:
		position = initialposition + (TILESIZE * inputdirection * percentmovedtonexttile)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_Q:
			randomize()
			dialogo = Dialogic.start(_revuelve(dialogs))
			dialogo.connect("dialogic_signal", self, "dialog_listener")	
			add_child(dialogo)			
			state = IDLE
			$Timer.stop()

func _on_Timer_timeout():
	state = _revuelve([IDLE, NEW_DIRECTION, MOVE])
	print(state)
	
func _revuelve(objeto):
	randomize()
	objeto.shuffle()
	return objeto.front()

func dialog_listener(string):
	match string:
		"termina":
			print('termina')
			$Timer.start(-1)
