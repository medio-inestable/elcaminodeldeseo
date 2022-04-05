extends Control

var timer_numero = 2

func _ready():
	pass # Replace with function body.



func _on_Timer_timeout():
	if timer_numero == 0:
		$numeros.bbcode_text = '[center]GO![/center]'
		timer_numero = timer_numero - 1
		Senales.emit_signal('termina_timer')
		return
		
	elif timer_numero == -1:
		$numeros.queue_free()
		timer_numero = timer_numero - 1
		return
	
	elif timer_numero < -1:
		queue_free()
		return
		
	$numeros.bbcode_text = '[center]'+str(timer_numero)+'[/center]'
	timer_numero = timer_numero - 1

