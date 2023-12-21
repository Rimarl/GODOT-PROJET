class_name Menu
extends Control

@onready var start = $MarginContainer/HBoxContainer/VBoxContainer/Button as Button
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Button2 as Button


func _ready():
	start.button_down.connect(on_start_pressed)
	exit.button_down.connect(on_exit_pressed)

func on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")
	
func on_exit_pressed() -> void:
	get_tree().quit()	
	
