extends RigidBody


func _ready():
	pass


func _on_Area_body_entered(body):
	print('recolecto')
	queue_free()
