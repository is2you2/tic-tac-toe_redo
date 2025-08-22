extends Control

@onready var toggle_turn_timer:= $NewPlay/vbox/vbox/timelimit/margin/hbox/tog
@onready var turn_timer_slider:= $NewPlay/vbox/vbox/timelimit/margin/hbox/HSlider
@onready var turn_timer_input:= $NewPlay/vbox/vbox/timelimit/margin/hbox/TextEdit
var selected_time_limit:= 30

func _on_tog_pressed():
	turn_timer_slider.editable = toggle_turn_timer.button_pressed
	turn_timer_input.editable = toggle_turn_timer.button_pressed


func _on_h_slider_value_changed(value):
	if not changed_from_input:
		turn_timer_input.text = ''
		turn_timer_input.placeholder_text = str(int(turn_timer_slider.value))
		selected_time_limit = 30
	changed_from_input = false

var changed_from_input:= false
func _on_text_edit_text_changed():
	turn_timer_slider.value = int(turn_timer_input.text)
	selected_time_limit = int(turn_timer_input.text)
	changed_from_input = true
