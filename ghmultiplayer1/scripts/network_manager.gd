extends Node

const PORT = 8080
const DEFAULT_IP = "127.0.0.1" # Localhost

@onready var host_btn = $HostButton
@onready var join_btn = $JoinButton
@onready var players_container = $PlayersContainer

# สมมติว่าคุณมี Scene ตัวละครเตรียมไว้แล้ว
var player_scene = preload("res://scene/player.tscn") 

func _ready():
	host_btn.pressed.connect(_on_host_pressed)
	join_btn.pressed.connect(_on_join_pressed)

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error != OK:
		print("สร้าง Server ไม่สำเร็จ!")
		return
	
	multiplayer.multiplayer_peer = peer
	print("Host สำเร็จ! รอผู้เล่น...")
	
	# เมื่อมีคนเชื่อมต่อเข้ามา ให้เรียกฟังก์ชัน spawn ตัวละคร
	multiplayer.peer_connected.connect(_add_player)
	
	# Spawn ตัวละครให้ตัวเอง (Host) ด้วย (ID ของ Host คือ 1 เสมอ)
	_add_player(1) 
	
	# ซ่อนปุ่ม
	host_btn.hide()
	join_btn.hide()

func _on_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(DEFAULT_IP, PORT)
	multiplayer.multiplayer_peer = peer
	print("กำลัง Join...")
	
	# ซ่อนปุ่ม
	host_btn.hide()
	join_btn.hide()

# ฟังก์ชันนี้จะถูกเรียกเฉพาะฝั่ง Host เท่านั้น
func _add_player(id):
	var player = player_scene.instantiate()
	# สำคัญมาก: ต้องตั้งชื่อ Node ตัวละครให้เป็น ID ของผู้เล่น เพื่อให้ระบบรู้ว่าใครเป็นเจ้าของ
	player.name = str(id) 
	player.position = Vector2(randi_range(10, 600+id/2), randi_range(10, 900+id/2))
	players_container.add_child(player)
	
