extends Area2D


#必须要在编辑器连上，这个名字是你随便乱取都可以的
#信号回调函数，命名格式为_on_节点名_信号名或者_on_信号名
#这个是area2d的body_entered信号的回调函数
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):#假如是玩家组的（group要在编辑器里设置）
		body.queue_free()#将玩家从场景中移除
		print("Player has died!")#打印玩家死亡
