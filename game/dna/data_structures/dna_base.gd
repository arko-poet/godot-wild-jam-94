class_name DNABase extends RefCounted

enum Shape {
	RoundSocket,  # --(
	RoundPlug,    # --)
	PointySocket, # --<
	PointyPlug     # -->
}
## TODO might may make more sense to define Attribute elsewhere
enum Attribute {HEALTH, DAMAGE, SPEED} 

var shape: Shape
var attribute: Attribute
var value: int ## magnitude of the attribute


func _init(p_shape: Shape, p_attribute: Attribute, p_value: int) -> void:
	shape = p_shape
	attribute = p_attribute
	value = p_value


func is_matching(base: DNABase) -> bool:
	match shape:
		Shape.RoundSocket:
			return base.shape == Shape.RoundPlug
		Shape.RoundPlug:
			return base.shape == Shape.RoundSocket
		Shape.PointySocket:
			return base.shape == Shape.PointyPlug
		Shape.PointyPlug:
			return base.shape == Shape.PointySocket
		_:
			push_error("Invalid base shape %s" % shape)
			return false
