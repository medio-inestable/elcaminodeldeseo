extends RichTextLabel


func _ready():
	pass


func _on_vueltaarea_pasa_meta(numero_vuelta):
	text = str(numero_vuelta)
