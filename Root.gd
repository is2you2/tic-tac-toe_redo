extends Node

# iframe 창
var window

var ws_recv_func = JavaScriptBridge.create_callback(ws_recv)
var webrtc_recv_func = JavaScriptBridge.create_callback(webrtc_recv)
var after_use_custom_act_func = JavaScriptBridge.create_callback(after_use_custom_act)
var toggle_bottom_menu_func = JavaScriptBridge.create_callback(toggle_bottom_menu)
var is_web_env:= false

func _ready():
	if OS.has_feature('web'):
		window = JavaScriptBridge.get_interface('window')
		window.ws_recv = ws_recv_func
		window.webrtc_recv = webrtc_recv_func
		window.after_use_custom_act = after_use_custom_act_func
		window.toggle_bottom_menu = toggle_bottom_menu_func
		is_web_env = true

# 게임에 참가할 때 수집한 게임 정보 확인하기 (stringified json)
func get_reqInfo():
	if is_web_env and window.get_reqInfo:
		var regInfo:String = window.get_reqInfo()
		return JSON.parse_string(regInfo)
	return null

# 빠른 진입용 서버 정보 업데이트
func update_reqInfo(str:String):
	if is_web_env and window.update_reqInfo:
		window.update_reqInfo(str)

# 상단 알림 토스트 생성하기
func show_toast(str:String):
	if is_web_env and window.show_toast:
		window.show_toast(str)

# 다른 페이지에서 함수 지정해주기
# Root.OnWsRecvFunc = Callable(self, "my_function")
var OnWsRecvFunc
# ArcadeWS 를 통해서 메시지를 수신받음 (Sample)
func ws_recv(args):
	var recv_str:String = args[0]
	if OnWsRecvFunc:
		OnWsRecvFunc.call([recv_str])

# ArcadeWS 를 사용하여 메시지 발송하기
func ws_send(str: String):
	if is_web_env and window.ws_send:
		window.ws_send(str)

# 다른 페이지에서 함수 지정해주기
# Root.OnWsRecvFunc = Callable(self, "my_function")
var OnWebRTCRecvFunc
# WebRTC 동시 연동시 수신받는 메시지
func webrtc_recv(args):
	var recv_str:String = args[0]
	if OnWebRTCRecvFunc:
		OnWebRTCRecvFunc.call([recv_str])

# ArcadeWS 를 사용하여 메시지 발송하기
func webrtc_send(str: String):
	if is_web_env and window.webrtc_send:
		window.webrtc_send(str)

# 앱에서 빠른 진입 QRCode 페이지 띄우기
func open_qrcode_modal():
	if is_web_env and window.open_modal:
		window.open_modal()

# 앱에서 빠른 진입 QRCode 모달 닫기
func close_qrcode_modal():
	if is_web_env and window.close_modal:
		window.close_modal()

# 현재 연결된 아케이드 WS PeerId 받기
func get_pid():
	if is_web_env and window.get_pid:
		return window.get_pid()
	return null

# 모바일 웹인지 환경을 검토함
func check_if_mobile():
	if is_web_env and window.check_mobile:
		return window.check_mobile()
	return null

# 사용자 내보내기
func kick_user(pid: String):
	if is_web_env and window.kick_user:
		window.kick_user(pid)

# 사용자 지정 아바타를 게임에서 직접 사용하기
# 사용자 지정 아바타 경로: user://custom_characters/[SocketId]/character.pck
# 기본 아바타 경로: user://custom_characters/default.pck
func use_user_custom_character():
	if is_web_env and window.use_custom_character:
		await window.use_custom_character()

# 다른 페이지에서 함수 지정해주기
# var open_custom_character = Callable(self, "my_function")
var open_custom_character
func after_use_custom_act(args):
	if open_custom_character:
		open_custom_character.call()

# 하단에 채팅 입력칸을 토글함, 강제 설정 가능
func toggle_chat_input(force_tog = null):
	if is_web_env and window.toggle_chat:
		window.toggle_chat(force_tog)

# 현재 앱에서 활성된 하단 메뉴 상태를 추적함
var current_bottom_menu = 'arcade'
# 앱에서 하단 탭을 눌러 다른 페이지로 이동시 이 함수로 문자열을 변경처리
func toggle_bottom_menu(args):
	var input_str = args[0]
	current_bottom_menu = input_str

# 게임 종료하기
func quit_game():
	if is_web_env and window.quit_game:
		window.quit_game()
