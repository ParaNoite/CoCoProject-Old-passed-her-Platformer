extends Sprite2D


@export var pickup_area: Area2D
# signal coin_collected()#自定义信号，金币被收集时发射
#这里跨节点通信太麻烦了，直接创建EventBus.gd，自动加载，所有脚本都可以直接访问
func _ready() -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):#假如是玩家组的（group要在编辑器里设置）
		queue_free()#将金币从场景中移除
		print("Coin collected!")#打印金币被收集
		EventBus.coin_collected.emit()#发射信号
		sound()#播放音效

func sound() -> void:
	# 1. 创建 AudioStreamPlayer
	var player := AudioStreamPlayer.new()
	
	# 2. 创建 AudioStreamGenerator 并设置参数
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = 22050  # 降低采样率节省性能
	generator.buffer_length = 0.5  # 缓冲区长度
	player.stream = generator
	
	# 3. 添加到场景并开始播放
	get_tree().current_scene.add_child(player)
	player.play()
	
	# 4. 获取播放回调
	var playback := player.get_stream_playback()
	
	# 5. 合成音效：高频衰减的"叮"声
	var sample_hz = generator.mix_rate
	var frequency = 1200.0  # 起始频率（高音）
	var decay = 0.998  # 衰减速度（每帧乘数）
	var amplitude = 0.8  # 初始振幅
	var phase = 0.0
	var duration_frames = int(sample_hz * 0.3)  # 持续0.3秒
	
	for i in range(duration_frames):
		# 等待缓冲区有空间
		while playback.get_frames_available() == 0:
			await get_tree().process_frame
		
		# 合成样本：频率随时间降低（产生"叮"的下坠感）
		var current_freq = frequency * (1.0 - i / float(duration_frames) * 0.7)
		var increment = current_freq / sample_hz
		
		# 振幅随时间衰减
		var current_amp = amplitude * pow(decay, i)
		
		# 生成左右声道信号（正弦波）
		var value = sin(phase * TAU) * current_amp
		playback.push_frame(Vector2(value, value))
		
		phase = fmod(phase + increment, 1.0)
	
	# 6. 播放完成后自动销毁
	player.finished.connect(player.queue_free)