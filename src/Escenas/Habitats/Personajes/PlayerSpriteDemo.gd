extends KinematicBody2D

export var walkspeed = 4.0
const TILESIZE = 16

onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var ray = $RayCast2D

enum PlayerState { IDLE, TURNING, WALKING}
enum FacingDirection {LEFT, RIGHT, UP, DOWN}

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

var initialposition = Vector2(0,0)
var inputdirection = Vector2(0,0)
var moving = false
var percentmovedtonexttile = 0.0

func _ready():
	anim_tree.active = true
	initialposition = position
	
func _physics_process(delta):
	if player_state == PlayerState.TURNING:
		return
	elif moving == false:
		process_player_input()
	elif inputdirection != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		moving = false
func process_player_input():
	if inputdirection.y == 0:
		inputdirection.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if inputdirection.x == 0:
		inputdirection.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if inputdirection != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", inputdirection)
		anim_tree.set("parameters/Walk/blend_position", inputdirection)
		anim_tree.set("parameters/Turn/blend_position", inputdirection)
		
		if need_to_turn():
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			initialposition = position
			moving = true
	else:
		anim_state.travel("Idle")

func need_to_turn():
	var new_facing_direction
	if inputdirection.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif  inputdirection.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif  inputdirection.y < 0:
		new_facing_direction = FacingDirection.UP
	elif  inputdirection.y > 0:
		new_facing_direction = FacingDirection.DOWN
	
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	facing_direction = new_facing_direction
	return false
	
func finished_turning():
	player_state = PlayerState.IDLE
	
func move(delta):
	percentmovedtonexttile += walkspeed * delta
	var desired_step: Vector2 = inputdirection * TILESIZE 
	ray.cast_to = desired_step
	ray.force_raycast_update()
	if !ray.is_colliding():
		if percentmovedtonexttile >= 1.0:
			position = initialposition + (TILESIZE * inputdirection)
			percentmovedtonexttile = 0.0
			moving = false
		else:
			position = initialposition + (TILESIZE * inputdirection * percentmovedtonexttile)
	else:
		percentmovedtonexttile = 0.0
		moving = false
