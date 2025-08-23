extends Control

func _ready():
	Root.OnWsRecvFunc = Callable(self, "_on_ws_recv")

func _on_ws_recv(args):
	var json_str:String = args[0]
	var json = JSON.parse_string(json_str)
	match json.type:
		'join':
			print('join')
			Root.close_qrcode_modal()
		'leave':
			print('leave')
			Root.quit_game()
		'update_reqInfo':
			# 게임 설정 성공시 QR코드 생성 후 진입 대기
			if json.result:
				Root.open_qrcode_modal()
			else: # 게임 설정 실패시 토스트 알림
				Root.show_toast('Failed to update game info')

@onready var title_node:= $Title
@onready var ingame_node:= $InGame

# 인 게임 화면으로 전환하기 (1회성)
func toggle_to_ingame():
	title_node.queue_free()
	ingame_node.visible = true
