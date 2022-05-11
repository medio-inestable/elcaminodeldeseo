extends KinematicBody2D

export var walkspeed = 4.0
const TILESIZE = 16

var initialposition = Vector2(0,0)
var inputdirection = Vector2(0,0)
var moving = false
var percentmovedtonexttile = 0.0

func _ready():
	initialposition = position
	
func _physics_process(delta):
	if moving == false:
		process_player_input()
	elif inputdirection != Vector2.ZERO:
		move(delta)
	else:
		moving = false
func process_player_input():
	if inputdirection.y == 0:
		inputdirection.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if inputdirection.x == 0:
		inputdirection.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if inputdirection != Vector2.ZERO:
		initialposition = position
		moving = true
		
func move(delta):
	percentmovedtonexttile += walkspeed * delta
	if percentmovedtonexttile >= 1.0:
		position = initialposition + (TILESIZE * inputdirection)
		percentmovedtonexttile = 0.0
		moving = false
	else:
		position = initialposition + (TILESIZE * inputdirection * percentmovedtonexttile)
