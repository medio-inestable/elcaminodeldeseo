extends Node

const SCENE_NAMES = preload("res://Escenas/Ambientes/ScenePaths.gd");

var nextLevel = null;

onready var viewPort = $SceneViewportContainer.get_child(0);
onready var animPlayer = $AnimationPlayer;

var currentLevel
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	currentLevel = viewPort.get_child(0)
	currentLevel.get_child(0).connect("changeLevel", self, "handleLevelChanged");

func handleLevelChanged(nextLevelName: String):
	nextLevel = load("res://Escenas/Ambientes/" + nextLevelName + ".tscn").instance();
	viewPort.add_child(nextLevel);
	animPlayer.play("Fade_Out");
	
	print("loaded " + nextLevelName);


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"Fade_Out":
			currentLevel.queue_free();
			currentLevel = nextLevel;
			currentLevel.get_child(0).connect("changeLevel", self, "handleLevelChanged");
			animPlayer.play("Fade_In");
