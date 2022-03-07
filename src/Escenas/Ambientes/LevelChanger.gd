extends Node

signal changeLevel(nextLevel);

func requestLevelChange(levelName : String) -> void:
	emit_signal("changeLevel", levelName);
