extends Spatial

onready var _timer : Timer = $Timer
export var num_piedras: int = 40

var piedra_l = load("res://Escenas/Habitats/Objetos/Obstaculo.tscn")

#add_child_below_node(get_tree().get_root().get_node("Game"),bullet)

func _ready():
	_crea_piedra()
	pass

func _crea_piedra():
	for i in range(num_piedras):
		var piedra = piedra_l.instance()
		piedra.translation.x = rand_range(-40, 40)
		piedra.translation.z = -i*45
		add_child_below_node(_timer, piedra)


	
