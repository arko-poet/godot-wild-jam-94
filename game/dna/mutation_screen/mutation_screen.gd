extends Node

signal mutation_finished

@onready var player_creature: Sprite2D = $World/PlayerCreature
@onready var corpse: Sprite2D = $World/Corpse

@onready var left_strand_drawing: DnaStrandDrawing = $World/LeftStrandDrawing
@onready var right_strand_drawing: DnaStrandDrawing = $World/RightStrandDrawing

@onready var mutation_h_box: HBoxContainer = $UILayer/UI/MutationHBox
@onready var confirm_mutation_button: Button = $UILayer/UI/MutationHBox/ConfirmMutationButton
@onready var skip_mutation_button: Button = $UILayer/UI/MutationHBox/SkipMutationButton

@onready var shift_strand_up_button: TextureButton = $UILayer/UI/ShiftStrandUpButton
@onready var shift_strand_down_button: TextureButton = $UILayer/UI/ShiftStrandDownButton

@onready var next_battle_button: Button = $UILayer/UI/NextBattleButton

var left_strand: DNAStrand
var right_strand: DNAStrand


func _ready() -> void:
	# TEST to be deleted
	load_dna_strands(Strands.get_random_strand(), Strands.get_random_strand())


## TODO change parameters to get creature objects - for adding sprites etc.
## p_left_strand -> player creature's strand that will change
## p_right_strand -> slain creature strand that will affect strandA
func load_dna_strands(p_left_strand: DNAStrand, p_right_strand: DNAStrand) -> void:
	left_strand = p_left_strand
	right_strand = p_right_strand
	
	left_strand_drawing.strand = left_strand
	right_strand_drawing.strand = right_strand
	right_strand_drawing.shift = 0
	
	next_battle_button.hide()
	mutation_h_box.show()


func _on_confirm_mutation_button_pressed() -> void:
	left_strand.combine_strands(right_strand, right_strand_drawing.shift, true)
	mutation_h_box.hide()
	next_battle_button.show()


func _on_skip_mutation_button_pressed() -> void:
	mutation_h_box.hide()
	next_battle_button.show()


func _on_shift_strand_up_button_pressed() -> void:
	right_strand_drawing.shift -= 1


func _on_shift_strand_down_button_pressed() -> void:
	right_strand_drawing.shift += 1


func _on_next_battle_button_pressed() -> void:
	mutation_finished.emit()
	print("MUTATION FINISHED, NEXT BATTLE REQUESTED")
