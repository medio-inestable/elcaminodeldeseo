extends "res://Codigos/Locales/Habitats/Objetos/carros.gd"

func get_input():
	var turn = Input.get_action_strength("steer_left")
	turn -= Input.get_action_strength("steer_right")
	steer_angle = turn * deg2rad(steering_limit)
	acceleration = Vector3.ZERO
	if Input.is_action_pressed("accelerate"):
		acceleration = -transform.basis.z * engine_power * 10
	if Input.is_action_pressed("break"):
		acceleration = -transform.basis.z * braking
	if Input.is_action_pressed("steer_left") or Input.is_action_pressed("steer_right"):
		steering_limit += 0.05
	if Input.is_action_just_released("steer_left") or Input.is_action_just_released("steer_right"):
		steering_limit = 0.5
		
