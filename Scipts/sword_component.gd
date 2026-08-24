extends Node2D

#所有有关剑的都在这，为了好的设计，这里只暴露一个接口叫做attack（）
@export var hurtbox: Area2D
@export var animation_player: AnimationPlayer
var can_atk:bool = true


func _ready() -> void:
	# hurtbox.on_body_entered.connect(_on_hurtbox_body_entered)
	pass
#唯一入口
func attack() -> void:
	if not can_atk:
		return
	animation_player.play("Swing1")
	print("Attack!")

#击杀逻辑
func _on_hurtbox_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		print("Enemy hit!")
		body.queue_free()
