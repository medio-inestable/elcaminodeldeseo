extends Spatial

var posicion
var rotacion
export var numero_carro:int

func _ready():
	posicion = translation
	rotacion = rotation
	Senales.emit_signal("spawnea_carro", posicion, rotacion, numero_carro)
	$CSGMesh.queue_free()
	$CSGMesh2.queue_free()
