extends Control


@onready var toggle_turn_timer:= $NewPlay/vbox/vbox/timelimit/margin/hbox/tog
@onready var turn_timer_slider:= $NewPlay/vbox/vbox/timelimit/margin/hbox/HSlider
@onready var turn_timer_input:= $NewPlay/vbox/vbox/timelimit/margin/hbox/TextEdit

func _on_tog_pressed():
	turn_timer_slider.editable = toggle_turn_timer.pressed
	turn_timer_input.editable = toggle_turn_timer.pressed
