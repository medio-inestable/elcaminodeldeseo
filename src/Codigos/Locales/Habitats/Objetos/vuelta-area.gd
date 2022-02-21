extends Area

var i = 0
signal pasa_meta(numero_vuelta)

func _ready():
	pass


func _on_vueltaarea_area_entered(area):
	print(area.name)
	if area.name == 'ColisionCarro':
		print(i)
		i = i + 1
		emit_signal("pasa_meta",i)
