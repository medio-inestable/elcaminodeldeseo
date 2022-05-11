extends Spatial

onready var conego = $conegito
onready var ani_conego = $conegito/flota
onready var ani_conego2 = $conegito/rota

var tiemposin:float = -1.0
var neg = 1

func _ready():
	ani_conego.play("flota")
	ani_conego2.play("rota")
	pass

func _process(delta):
	_gira_modelo(conego)

func _gira_modelo(modelo):	
	pass
#	modelo.rotate_y(PI*get_process_delta_time()*0.2)
	
