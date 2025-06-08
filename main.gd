extends Control

var _test_paths: PackedStringArray
var _test_menu_popup: PopupMenu

var _current_test: Control

@onready var test_menu: MenuButton = $MarginContainer/VBoxContainer/HBoxContainer/MenuButton
@onready var test_parent: Control = $MarginContainer/VBoxContainer/MarginContainer/Control
@onready var current_test_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label


func _ready() -> void:
	_test_paths = DirAccess.open("res://tests/").get_files()
	
	_test_menu_popup = test_menu.get_popup()
	_test_menu_popup.index_pressed.connect(_on_popup_index_pressed)
	
	for path: String in _test_paths:
		_test_menu_popup.add_item(path)
	
	await get_tree().process_frame
	
	_on_popup_index_pressed(_test_paths.size() - 1)


func _on_popup_index_pressed(index: int) -> void:
	if is_instance_valid(_current_test):
		_current_test.queue_free()
	
	var ps: PackedScene = load("res://tests/" + _test_paths[index]) as PackedScene
	
	if not is_instance_valid(ps):
		current_test_label.text = "Failed to load test at path: res://tests/" + _test_paths[index]
		return
	
	_current_test = ps.instantiate()
	
	test_parent.add_child(_current_test)
	
	_current_test.position = (test_parent.size / 2.0) - (_current_test.size / 2.0)
	
	current_test_label.text = "Current test: " + _test_paths[index]
	
	var first_button: Button = _current_test.find_child("Start")
	
	if is_instance_valid(first_button):
		first_button.grab_focus()
