extends CharacterBody2D

@export var max_speed = 850
@export var accel = 8600
@export var fliction = 8300

var input:Vector2

func get_input():
	input.x = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))
	input.y = int(Input.is_action_pressed('move_down')) - int(Input.is_action_pressed('move_up'))
	return input.normalized()
	
@onready var Multi_p_sync  = $MultiplayerSynchronizer
func player_movement(delta):
	if not Multi_p_sync.is_multiplayer_authority():
	#if name != "1":
		return
		
	input = get_input()
	if input == Vector2.ZERO:
		#print('not moving')
		if velocity.length() > fliction*delta :
			#print(fliction*delta)
			velocity -= velocity.normalized()* (fliction*delta)
		else : velocity = Vector2.ZERO
		#print(velocity.length())
	else : 
		velocity += input*accel*delta 
		velocity = velocity.limit_length(max_speed)

func _physics_process(delta):
	player_movement(delta)
	move_and_slide()


func _enter_tree():
	# กำหนดสิทธิ์ควบคุม (Authority) ทันทีที่ตัวละครถูกสร้างขึ้นมาใน Scene
	# โดยอ้างอิงจากชื่อ Node ซึ่งเราตั้งค่าให้เป็นรหัส ID ผู้เล่นไว้แล้วในขั้นตอนที่แล้ว
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

@onready var cam:Camera2D = $Camera2D

func _ready():
	# (ทางเลือก) หากในตัวละครมีกล้อง Camera ติดอยู่ด้วย 
	# เราต้องสั่งให้กล้องทำงานเฉพาะตัวละครที่เป็นของเราเท่านั้น
	if $MultiplayerSynchronizer.is_multiplayer_authority():
		global_position = Vector2(randi_range(100, 400), randi_range(100, 400))
		self.modulate = Color(randf_range(0.4, 1), randf_range(0.4,1), randf_range(0.4, 1),1)
	
	cam.enabled = $MultiplayerSynchronizer.is_multiplayer_authority()
