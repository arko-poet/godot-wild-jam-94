class_name DNABaseDrawing extends Sprite2D

@onready var label: Label = $Label


func set_dna_base(base: DNABase, aligned_left := true) -> void:
	label.text = "%s" % base.value
	
	change_alignement(aligned_left)


func change_alignement(aligned_left := true) -> void:
	if aligned_left:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	else:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
	flip_h = !aligned_left
