extends CanvasLayer

@export var game_over_ui: Control
@export var num_coins_label: Label
func _ready() -> void:
	#上至场景树，找组，连接信号，当玩家死亡时，调用_on_player_died函数
	get_tree().get_first_node_in_group("Player").player_died.connect(_on_player_died)
	EventBus.coin_collected.connect(_on_coin_collected)#总线
	game_over_ui.visible = false


func _on_player_died() -> void:
	#当玩家死亡时，显示游戏结束UI
	game_over_ui.visible = true
	print("Player has died. Game Over UI is now visible.")

func _on_coin_collected() -> void:
	#当金币被收集时，更新金币数量显示
	num_coins_label.text = "你个艾斯贼偷吃我的金币真的是石螺母了"
