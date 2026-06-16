class_name DNABaseDrawing extends Sprite2D

const DNA_ELEMENTS_PATH := "res://assets/art/AssetsDNAScreen_x2/DNAelements/%sDNA_%s_%s.png"
const DNA_SHAPE_MAPPING: Dictionary[DNABase.Shape, int] = {
	DNABase.Shape.RoundSocket: 2,
	DNABase.Shape.RoundPlug: 2,
	DNABase.Shape.PointySocket: 1,
	DNABase.Shape.PointyPlug: 1
}
const DNA_PLUG_SOCKET_MAPPING: Dictionary[DNABase.Shape, int] = {
	DNABase.Shape.RoundSocket: 2,
	DNABase.Shape.RoundPlug: 1,
	DNABase.Shape.PointySocket: 2,
	DNABase.Shape.PointyPlug: 1
}
const DNA_COLOR_MAPPING: Dictionary[DNABase.Attribute, String] = {
	DNABase.Attribute.HEALTH: "Green",
	DNABase.Attribute.DAMAGE: "Orange",
	DNABase.Attribute.SPEED: "Blue"
}

@onready var label: Label = $Label

func set_dna_base(base: DNABase, aligned_left := true) -> void:
	label.text = "%s" % base.value
	_update_texture(base)
	
	change_alignement(aligned_left)


func change_alignement(aligned_left := true) -> void:
	if aligned_left:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	else:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
	flip_h = !aligned_left


func _update_texture(base: DNABase) -> void:
	texture = load(DNA_ELEMENTS_PATH % [DNA_COLOR_MAPPING[base.attribute], DNA_SHAPE_MAPPING[base.shape], DNA_PLUG_SOCKET_MAPPING[base.shape]])
