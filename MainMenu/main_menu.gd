extends Control

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://MainMenu/SettingsMenu.tscn")

func _on_quit_pressed():
	get_tree().quit()
