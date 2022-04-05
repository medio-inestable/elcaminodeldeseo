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
onready var _velocimetro = $velocimetro
onready var _laps = $laps
onready var _ganaste_carrera = $ganaste_carrera
onready var _nombre_ganador = $ganaste_carrera/nombre_ganador
onready var _rechinido = $TsuruAlterado/rechinido
onready var _acelera_s = $TsuruAlterado/acelera


export var player_number:int = 1

# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, 0, 0)
var camara_offset = Vector3(0, 0, 0)
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
var frame:int = 0

# Variables for input values
var speed_input = 0
var rotate_input = 0

var body_tilt = 50

var piso = false
var camara_transform

var inicia_juego = false

var input_names = {"brake":'brake', "accelerate":'accelerate', "steer_right":'steer_right',"steer_left":'steer_left'}


func _ready():	
	Senales.connect("dio_vuelta",self,"_dio_vuelta")
	Senales.connect("spawnea_carro", self, "_spawnea_carro")
	Senales.connect("termina_carrera", self, "_termina_carrera")
	Senales.connect("termina_timer", self, "_inicia_juego")
	$TsuruAlterado/Area.name = 'Area_carro_' + str(player_number)
	_nombre_ganador.bbcode_text = '[center][wave amp=100 freq=1.5][rainbow freq=1 sat=2 val=10]Jugadorx ' + str(player_number) + '[/rainbow][/wave][/center]'
	ground_ray.add_exception(ball)	
	input_names.brake = input_names.brake + '_' + str(player_number)
	input_names.accelerate = input_names.accelerate + '_' + str(player_number)
	input_names.steer_left = input_names.steer_left + '_' + str(player_number)
	input_names.steer_right = input_names.steer_right + '_' + str(player_number)

func _physics_process(_delta):
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	spring.transform.origin = ball.transform.origin + camara_offset
	if not inicia_juego:
		return
	# Keep the car mesh aligned with the sphere
	
	# Accelerate based on car's forward direction
	ball.add_central_force(car_mesh.global_transform.basis.z * speed_input)
	
	
func _process(delta):
	# Can't steer/accelerate when in the air
#	_colision_carro.transform.origin = car_mesh.transform.origin
	frame = (frame + 1)%5
	if not inicia_juego:
		return
	if not piso:	
		return
	# Get accelerate/brake input
	speed_input = 0
	speed_input += Input.get_action_strength(input_names.brake) - Input.get_action_strength(input_names.accelerate) 
#	speed_input -= Input.get_action_strength("brake")
	speed_input *= acceleration	
	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength(input_names.steer_left)
	rotate_input -= Input.get_action_strength(input_names.steer_right)
	rotate_input *= deg2rad(steering)	
	right_wheel.rotation.y = rotate_input*2 - 90
	left_wheel.rotation.y = rotate_input*2 - 90
	
	camara.fov = clamp(lerp(camara.fov,ball.linear_velocity.length(),delta),46,60)
	
	if frame == 4:
		_velocimetro.bbcode_text = str(floor(ball.linear_velocity.length()*2)) + 'km/h'
		_acelera_s.volume_db = clamp(lerp(_acelera_s.volume_db,((ball.linear_velocity.length()*0.23)-25),delta),-16,-9)
		print(_acelera_s.volume_db)
	
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
#		var new_basis_spring = spring.global_transform.basis.rotated(spring.global_transform.basis.y, rotate_input)		
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
#		spring.global_transform.basis = spring.global_transform.basis.slerp(new_basis, turn_speed * delta)
#		spring.global_transform = spring.global_transform.orthonormalized()
		spring.rotation.y = lerp_angle(spring.rotation.y,car_mesh.rotation.y,6*delta)
		# rotate wheels for effect

		# tilt body for effect
		var t = -rotate_input*6 * ball.linear_velocity.length() / body_tilt
		car_mesh.rotation.z = lerp(car_mesh.rotation.z, t, 10 * delta)
#		spring.rotation.z = lerp(spring.rotation.z, -t, 10 * delta)

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
		if Input.is_action_just_pressed(input_names.steer_left) && !_girando:
			_particulas_gira.emitting = true
			_rechinido.play(0.4)
			_rechinido.stream_paused = false
#			_polvo.emitting = true
			_girando = true
		if Input.is_action_just_released(input_names.steer_left):
			_particulas_gira.emitting = false
			_rechinido.stream_paused = true
#			_polvo.emitting = false
			_girando = false
		if Input.is_action_just_pressed(input_names.steer_right) && !_girando:
			_particulas_gira_derecha.emitting = true
			_rechinido.play(0.4)
			_rechinido.stream_paused = false
#			_polvo.emitting = true
			_girando = true
		if Input.is_action_just_released(input_names.steer_right):
			_particulas_gira_derecha.emitting = false
			_rechinido.stream_paused = true
#			_polvo.emitting = false
			_girando = false
		if Input.is_action_pressed(input_names.accelerate):
			_polvo.emitting = true
#			_acelera_s.play()
			_acelera_s.stream_paused = false
		if Input.is_action_just_released(input_names.accelerate):
			_polvo.emitting = false
			_acelera_s.stream_paused = true

func _on_Area_body_entered(body):
	piso = true

func _dio_vuelta(carro, vuelta):
	if carro == 'Area_carro_'+str(player_number):
		_laps.bbcode_text = str(vuelta)
		
	
func _spawnea_carro(posicion, rotacion, numero_carro):
	if numero_carro == player_number:
		translation = posicion
		rotation.y = rotacion.y

func _termina_carrera(carro):
	if carro == 'Area_carro_'+str(player_number):
		_ganaste_carrera.visible = true
		_laps.visible = false
		_velocimetro.visible = false
		acceleration = 40

func _inicia_juego():
	inicia_juego = true
