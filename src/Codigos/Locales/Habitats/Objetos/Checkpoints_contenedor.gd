extends Spatial

var checkpoints
var checkpoint_actual_1 = -1
var checkpoint_siguiente_1
var vuelta_1 = 0
var checkpoint_actual_2 = -1
var checkpoint_siguiente_2
var vuelta_2 = 0
export var total_vueltas:int = 3

func _ready():
	Senales.connect("entro_checkpoint", self, "_paso_checkpoint")
	checkpoints = get_children()
	checkpoint_siguiente_1 = checkpoint_actual_1 + 1
	checkpoint_siguiente_2 = checkpoint_actual_2 + 1
	for checkpoint in checkpoints:
		print(checkpoint.numero)
	pass

func _paso_checkpoint(numero, carro):
	match (carro):
		'Area_carro_1':
			if numero >= checkpoint_siguiente_1:
				if numero > checkpoint_siguiente_1 + 2:
					pass
				else:
					checkpoint_actual_1 = numero
					checkpoint_siguiente_1 = (checkpoint_actual_1 + 1)%checkpoints.size()
					if checkpoint_actual_1 == 0:
						vuelta_1 = vuelta_1 + 1
						Senales.emit_signal("dio_vuelta", carro, vuelta_1)
						if vuelta_1 == total_vueltas:
							Senales.emit_signal("termina_carrera", carro)
					
		'Area_carro_2':
			if numero >= checkpoint_siguiente_2:
				if numero > checkpoint_siguiente_2 + 2:
					pass
				else:
					checkpoint_actual_2 = numero
					checkpoint_siguiente_2 = (checkpoint_actual_2 + 1)%checkpoints.size()
					if checkpoint_actual_2 == 0:
						vuelta_2 = vuelta_2 + 1
						Senales.emit_signal("dio_vuelta", carro, vuelta_2)
						if vuelta_2 == total_vueltas:
							Senales.emit_signal("termina_carrera", carro)
					
