extends KinematicBody

export var speed := 7.0
export var max_speed := 150.0
export var gravity := 50.0
export var _rango_shake := 0.8

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _spring_arm: SpringArm = $SpringArm
onready var _model: Spatial = $Tsuru/TsuruAlterado
onready var _camera: Camera = $SpringArm/Camera
onready var _particulas_gira: Particles = $Particulas_gira
onready var _particulas_gira_derecha: Particles = $Particulas_gira_derecha


var _rotacion_modelo := 0.0
var _chocando := false
var _chocando_shake := false
var _girando := false

# Aqui esperamos que el modelo exista para poder sacar su rotacion inicial
func _ready():
	_rotacion_modelo = _model.rotation.y

# Funcion principal que se llama todo el tiempo
func _physics_process(delta):
	var move_direction := Vector3.ZERO	
	move_direction.x = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	
	rotation_degrees.y += -rad2deg(move_direction.x*4)*delta
	
	
#	Rotacion del spring arm para dar movimiento de camara distinto del carro
	_spring_arm.rotation_degrees.y += -rad2deg(move_direction.x*4)*delta
	_spring_arm.rotation_degrees.y -= _spring_arm.rotation_degrees.y*delta*6.5
	
#	Aqui solamente avanzas para adelante y solo dando break pues desaceleras
	move_direction.z = (Input.get_action_strength("brake")*2) - 1 
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	
#	En estas lineas rota el auto para que se vea mas alocado
	_model.rotation.x = -move_direction.x	
	_model.rotation.y = (-move_direction.x * 0.3) + _rotacion_modelo
		
#	Aumenta la velocidad 
	_velocity.x = move_direction.x * 1.6 * speed
	_velocity.z += move_direction.z * speed * delta
	_velocity.y = gravity * -delta
	_velocity.z = clamp(_velocity.z, -max_speed,1)
	
#	Cambia el FOV de la camara dependiendo de la velocidad y la limita de 5 a 100
	_camera.fov = clamp(-_velocity.z, 5, 100)
	if _girando:
		var random_offset = rand_range(0,0.1)
		_camera.h_offset = random_offset
		_camera.v_offset = random_offset*2
	if _chocando_shake:
		var random_offset = rand_range(0,_rango_shake)
		var random_offset_2 = rand_range(0,_rango_shake)
		_camera.h_offset = random_offset
		_camera.v_offset = random_offset_2
	
#	En esta linea hace la parte de aceleracion ya completa con el move_and_slide
	
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)	
	
	

#Cuando entra al rango del objeto llama la funcion choca()
func _on_Area_area_entered(area):
	choca()	

func _input(event):
	if !_chocando:
		if Input.is_action_just_pressed("steer_right") && !_girando:
			_particulas_gira.emitting = true
			_girando = true
		if Input.is_action_just_released("steer_right"):
			_particulas_gira.emitting = false
			_girando = false
		if Input.is_action_just_pressed("steer_left") && !_girando:
			_particulas_gira_derecha.emitting = true
			_girando = true
		if Input.is_action_just_released("steer_left"):
			_particulas_gira_derecha.emitting = false
			_girando = false
#
#	if Input.is_action_just_pressed("accelerate"):
#		print('acelera')
#		speed = 84
#		max_speed = 1550.0
#	if Input.is_action_just_released("accelerate"):
#		print('desacelera')
#		speed = 7
#		max_speed = 150.0
		

#Funcion que hace que choque
func choca():
	var velocidad_actual = _velocity.z
#	_chocando tiene que ser falso para que no se llame la funcion si chocas varias veces
	if !_chocando:
		$AnimationPlayer.play("Choca")		
		_velocity.z = clamp(velocidad_actual + 45, -80, -30)
		_chocando = true
		_chocando_shake = true
		_girando = false
		_particulas_gira.emitting = false
		_particulas_gira_derecha.emitting = false
		Engine.time_scale = 0.1
		yield(get_tree().create_timer(0.07), "timeout")
		
		Engine.time_scale = 1			
#		Despues de 3 segundos ya puedes volver a chocar
		yield(get_tree().create_timer(2.4), "timeout")		
		_chocando_shake = false
		_chocando = false
