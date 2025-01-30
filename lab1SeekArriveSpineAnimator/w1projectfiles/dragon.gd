extends CharacterBody3D

@export var target1:Node3D
@export var target2:Node3D
@export var force:Vector3
@export var accel:Vector3
@export var mass:float = 1
@export var max_speed: float = 10
@export var slowing_radius: float = 15.0 
@export var stop_radius: float = 8

@export var ui_label: Label

var current_target: Node3D
var mode: String = "seek"
var arrival_threshold: float = 0.1

func seek(target) -> Vector3:
	var to_target:Vector3 = target.global_position - global_position
	var desired = to_target.normalized() * max_speed
	return desired - velocity

func arrive(target) -> Vector3:
	var to_target: Vector3 = target.global_position - global_position
	var distance = to_target.length()
	
	# Immediate stop condition
	if distance < stop_radius:
		return -velocity  # Apply direct braking force
	
	# Calculate normal arrive force
	var desired_speed = max_speed * (distance / slowing_radius)
	desired_speed = min(desired_speed, max_speed)
	var desired_velocity = to_target.normalized() * desired_speed
	return desired_velocity - velocity

func draw_gizmos():
	DebugDraw3D.draw_arrow(global_position, global_position + force, Color.AQUAMARINE, 0.1)
	DebugDraw3D.draw_arrow(global_position, global_position + velocity, Color.CRIMSON, 0.1)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			mode = "seek"
			current_target = target1
			ui_label.text = "Seek"
		elif event.keycode == KEY_2:
			mode = "arrive"
			current_target = target2
			ui_label.text = "Arrive"

func _ready():
	ui_label.text = "Seek"
	current_target = target1

func _physics_process(delta: float) -> void:
	if not current_target:
		return
	
	if mode == "seek":
		force = seek(current_target)
	else:
		force = arrive(current_target)
	
	accel = force / mass
	velocity = (velocity + accel * delta).limit_length(max_speed)
	
	if velocity.length() > 0:
		look_at(global_position + velocity)
		
	move_and_slide()
	draw_gizmos();
	pass
