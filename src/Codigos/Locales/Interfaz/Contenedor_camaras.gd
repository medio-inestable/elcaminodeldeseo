extends Control

export var numero_jugadores:int = 0

onready var jugador_1 = $"1Jugador"
onready var jugador_2 = $"2Jugadores"

func _ready():
#	Si es 0 va a tomar el numero de jugadores de la escena global Globales con senal de MenuMultiplayer
#	cambia el 0 en la escena Pista_pruba por cualquier otro para tomarlo desde ahi
	if numero_jugadores == 0:
		numero_jugadores = Globales.numero_jugadores	
	
	match numero_jugadores:
		1:
			print('1 jugador')
			jugador_2.queue_free()
		2:
			print('2 jugadores')
			jugador_1.queue_free()

