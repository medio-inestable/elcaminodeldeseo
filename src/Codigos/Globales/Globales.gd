extends Node

var numero_jugadores:int = 0

func _ready():
	Senales.connect("elige_multiplayer", self, "cambia_jugadores")
	
func cambia_jugadores(jugadores):
	numero_jugadores = jugadores
