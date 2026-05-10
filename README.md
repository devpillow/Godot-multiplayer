พัฒนา Multiplayer ด้วย Godot
จะต้องเข้าใจ 3 Keywords หลัก ๆ ก่อน
1. MultiplayerPeer - ทำหน้าที่เป็นเส้นทาง ที่จะถูกใช้ในการสื่อสารระหว่าง C/C หรือ Client/Server [ใน Project ใช้เป็น Websocket]
2. MultiplayerSpawner - ใช้สำหรับเช็ค Node ที่กำหนด ถ้ามี child ถูกแอดเข้ามาหรือถูกลบ จะไปบอกทุกคนผ่าน WS ด้วย MultiplayerPeer
3. MultiplayerSynchronizer - ใช้สำหรับอัพเดต Attribute ของตัว player โดยผ่าน MultiplayerPeer

ทั้ง MultiplayerSpawner/MultiplayerSynchronizer จะส่งข้อมูลอัตโนมัตจากโค้ด
`multiplayer.multiplayer_peer = peer`

URL websocket example
```swift
const PORT = 8080
const URL = "ws://127.0.0.1:8080" #Websocket
const URL = "wss://rejoin-erasure-evaluate.ngrok-free.dev" #ngrok```
```
Host
```swift
    var peer = WebSocketMultiplayerPeer.new()
    var error = peer.create_server(PORT)
    if error != OK:
        print("สร้าง Server (WebSocket) ไม่สำเร็จ!")
        return
    
    multiplayer.multiplayer_peer = peer
    print("Host (WebSocket) สำเร็จ! รอผู้เล่น...")
    
    multiplayer.peer_connected.connect(_add_player)
#_add_player(1) #ตัวhostอาจจะเป็นหนึ่งในผู้เล่น```

Client
```swift
var peer = WebSocketMultiplayerPeer.new()
    # ใช้ URL แบบ ws:// แทน IP เปล่าๆ
    var error = peer.create_client(URL) 
    if error != OK:
        print("เชื่อมต่อไม่สำเร็จ!")
        return
    multiplayer.multiplayer_peer = peer
    print("กำลัง Join ผ่าน WebSocket...")```

___

สามารถรู้ได้ว่า Player ตัวไหน คือตัวเราได้จากการเรียก
`$MultiplayerSynchronizer.is_multiplayer_authority()` ตัวที่ไม่ใช่ <-> `false`

สำคัญ : จะต้อง `$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())` โดยให้ `str(name).to_int()`แทน id ของตัวเอง ตั้งแต่ตอนที่ `_add_player(id)` โดยในโปรเจคตัวอย่างจะฝาก `id` ไว้กับ `name` ไปก่อน
