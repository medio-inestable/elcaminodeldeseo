extends Spatial

# Node references
onready var ball = $Esfera
onready var car_mesh = $TsuruAlterado
onready var ground_ray = $TsuruAlterado/RayCast
onready var camara = $SpringArm/Camera
onready var spring = $SpringArm
onready var right_wheel = $TsuruAlterado/Llanta_D_Der
onready var left_wheel = $TsuruAlterado/Llanta_D_Izq
onready var _particulas_gira: Particles = $TsuruAlterado/Particulas_gira
onready var _particulas_gira_derecha: Particles = $TsuruAlterado/Particulas_gira_derecha
onready var _polvo: Particles = $TsuruAlterado/Polvo
onready var _colision_carro = $ColisionCarro

# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, 0, 0)
var camara_offset = Vector3(0, 8.0, 0)
var _chocando = false
var _girando = false
# Engine power
export var acceleration = 50
# Turn amount, in degrees
export var steering = 21.0
# How quickly the car turns
export var turn_speed = 5
# Below this speed, the car doesn't turn
var turn_stop_limit = 0.75

# Variables for input values
var speed_input = 0
var rotate_input = 0

var body_tilt = 50

var piso = false
var camara_transform



func _ready():
	ground_ray.add_exception(ball)
#	camara_transform = camara.global_transform

func _physics_process(_delta):
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	spring.transform.origin = ball.transform.origin + camara_offset
	# Accelerate based on car's forward direction
	ball.add_central_force(car_mesh.global_transform.basis.z * speed_input)
	
	
func _process(delta):
	# Can't steer/accelerate when in the air
#	_colision_carro.transform.origin = car_mesh.transform.origin
	
	if not piso:
#		print(ground_ray)
		return
	# Get accelerate/brake input
	speed_input = 0
	speed_input += Input.get_action_strength("brake") - Input.get_action_strength("accelerate") 
#	speed_input -= Input.get_action_strength("brake")
	speed_input *= acceleration
	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg2rad(steering)	
	right_wheel.rotation.y = rotate_input*2 - 90
	left_wheel.rotation.y = rotate_input*2 - 90

	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		var new_basis_spring = spring.global_transform.basis.rotated(spring.global_transform.basis.y, rotate_input)		
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		spring.global_transform.basis = spring.global_transform.basis.slerp(new_basis_spring, turn_speed * delta)
		spring.global_transform = spring.global_transform.orthonormalized()
		# rotate wheels for effect

		# tilt body for effect
		var t = -rotate_input*6 * ball.linear_velocity.length() / body_tilt
		car_mesh.rotation.z = lerp(car_mesh.rotation.z, t, 10 * delta)
#		spring.rotation.z = lerp(spring.rotation.z, t, 10 * delta)

#	_colision_carro.transform.basis = car_mesh.global_transform.basis
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)
	
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
	
	

func _input(event):
	if !_chocando:
		if Input.is_action_just_pressed("steer_left") && !_girando:
			_particulas_gira.emitting = true
			_polvo.emitting = true
			_girando = true
		if Input.is_action_just_released("steer_left"):
			_particulas_gira.emitting = false
			_polvo.emitting = false
			_girando = false
		if Input.is_action_just_pressed("steer_right") && !_girando:
			_particulas_gira_derecha.emitting = true
			_polvo.emitting = true
			_girando = true
		if Input.is_action_just_released("steer_right"):
			_particulas_gira_derecha.emitting = false
			_polvo.emitting = false
			_girando = false

func _on_Area_body_entered(body):
	piso = true
	print(body.name)
