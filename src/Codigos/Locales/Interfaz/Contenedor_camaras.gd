extends Control

export var numero_jugadores:int = 1

onready var jugador_1 = $"1Jugador"
onready var jugador_2 = $"2Jugadores"

func _ready():
	match numero_jugadores:
		1:
			print('1 jugador')
			jugador_2.queue_free()
		2:
			print('2 jugadores')
			jugador_1.queue_free()
	pass
