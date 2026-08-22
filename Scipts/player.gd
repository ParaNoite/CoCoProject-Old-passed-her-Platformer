extends CharacterBody2D
#export的变量可以在编辑器里设置，方便调试
@export var speed := 200.0
@export var jump_velo := -400.0
@export var gravity := 10
#onready的变量会在ready函数里初始化，ready函数会在节点进入场景树时调用
@onready var ani_player: AnimationPlayer = $AnimationPlayer#这个名字是编辑器那个

func _ready() -> void:
	#设置玩家组，方便在死亡区域检测
	add_to_group("Player")#也可以直接在编辑器里设置
	#animation节点的引用可以有很多种，以下再展示
	# for child in get_children():#类似python的，其中child你随便取名字，get_children()是获取所有子节点的函数
	# 	if child is AnimatedSprite2D:
	# 		ani_player = child
	# 		break





#物理帧处理，每帧都会干的事情。和_process差不多，比_process更适合处理物理相关的逻辑
#冷知识：带有_的函数要不就是内置的函数，要不就是约定俗成的private函数，但python和gds没有private protected等限制的方案
func _physics_process(delta: float) -> void:
	if not is_on_floor():#characterbody2d自带的函数，判断是否在地面上
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velo
		ani_player.play("jump")#起跳瞬间播jump

	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	move_and_slide()#自带的移动方法，类似的还有move_and_collide()

	if not is_on_floor():
		pass
	elif direction != 0:
		ani_player.play("move")
	else:
		ani_player.play("idle")
