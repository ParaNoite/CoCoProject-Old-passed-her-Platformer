extends Area2D


#必须要在编辑器连上，这个名字是你随便乱取都可以的
#信号回调函数，命名格式为_on_节点名_信号名或者_on_信号名
#这个是area2d的body_entered信号的回调函数
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):#假如是玩家组的（group要在编辑器里设置）
		body.player_died.emit()#先通知订阅者（UI等）
		body.queue_free()#再将玩家从场景中移除
		print("Player has died!")#打印玩家死亡
		#创建一个计时器（临时）
		var timer = Timer.new()#创建一个计时器
		timer.wait_time = 2.0#设置计时器的等待时间为2
		timer.one_shot = true#设置计时器为单次计时
		timer.timeout.connect(_on_timer_timeout)#连接计时器的timeout信号到回调函数
		add_child(timer)#将计时器添加到当前节点下
		timer.start()#启动计时器
		Engine.time_scale = 0.5#设置游戏时间缩放为0.5，慢动作效果


func _on_timer_timeout() -> void:
	print("Timer timeout!")
	for timer in get_children():
		if timer is Timer:
			timer.queue_free()#遍历删除计时器
	Engine.time_scale = 1.0#恢复游戏时间缩放为1.0
	get_tree().reload_current_scene()#重新加载当前场景
