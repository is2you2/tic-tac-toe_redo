extends Control

@onready var title_node:= $Title
@onready var ingame_node:= $InGame

# 인 게임 화면으로 전환하기 (1회성)
func toggle_to_ingame():
	title_node.queue_free()
	ingame_node.visible = true
