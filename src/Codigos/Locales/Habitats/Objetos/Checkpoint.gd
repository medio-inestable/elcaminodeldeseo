extends Area

export var numero:int
var carro

func _ready():
	pass


func _on_Checkpoint_area_entered(area):
	carro = area.name
	Senales.emit_signal("entro_checkpoint", numero, carro)
	
