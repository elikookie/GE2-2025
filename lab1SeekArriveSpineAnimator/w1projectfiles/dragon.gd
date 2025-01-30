extends CharacterBody3D

@export var target:Node3D
@export var force:Vector3
@export var accel:Vector3
@export var mass:float = 1

var max_speed = 10

func seek(target) -> Vector3:
	var to_target:Vector3 = target.global_position - global_position
	var desired = to_target.normalized() * max_speed
	return desired - velocity

func draw_gizmos():
	DebugDraw3D.draw_arrow(global_position, global_position + force, Color.AQUAMARINE, 0.1)
	DebugDraw3D.draw_arrow(global_position, global_position + velocity, Color.CRIMSON, 0.1)

func _physics_process(delta: float) -> void:
	force = seek(target)
	
	accel = force / mass
	
	velocity = (velocity + accel * delta)
	
	if velocity.length() > 0:
		look_at(global_position + velocity)
	
	move_and_slide()	
	
	draw_gizmos();
	pass
