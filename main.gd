extends Control

var useLimit:bool = false
var timelimit:int = 30.0
var ReadyToStart:= false

func _ready():
	Root.OnWsRecvFunc = Callable(self, "_on_ws_recv")
	var json = Root.get_reqInfo()
	if json != null:
		print('_ready')
		ReadyToStart = true
		Root.toggle_chat_input(true)
		_set_game_settings(json.data.useLimit, json.data.timelimit)
		title_node.queue_free()
		ingame_node.show()

func _set_game_settings(_useLimit:bool, _timelimit:int):
	useLimit = _useLimit
	timelimit = _timelimit
	print('_set_game_settings')
	ReadyToStart = true

func _on_ws_recv(args):
	var json_str:String = args[0]
	var json = JSON.parse_string(json_str)
	print(json,'/',ReadyToStart)
	match json.type:
		'join':
			var my_pid:String = Root.get_pid()
			var joiner:String = json.uid
			# 내가 아닌 사람이 진입한 경우 자동으로 동작
			if my_pid != joiner:
				Root.close_qrcode_modal()
				Root.toggle_chat_input(true)
				title_node.queue_free()
				ingame_node.show()
		'leave':
			Root.show_toast('Game over: The other person leaves')
			await get_tree().create_timer(3).timeout
			Root.quit_game()
		'update_reqInfo':
			# 게임 설정 성공시 QR코드 생성 후 진입 대기
			if ReadyToStart:
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
