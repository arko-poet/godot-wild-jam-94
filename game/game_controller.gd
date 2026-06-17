class_name GameController extends Control

@onready var autobattler: Autobattler = %Autobattler
var mutation_screen: MutationScreen


func _ready() -> void:
	autobattler.autobattle_finished.connect(_initiate_mutation)
	mutation_screen = %MutationScreen
	mutation_screen.mutation_finished.connect(_initiate_autobattler)


func _initiate_mutation():
	mutation_screen.left_strand = autobattler.ally_party[0].dna_strand
	mutation_screen.right_strand = autobattler.enemy_party[0].dna_strand
	mutation_screen.show()
	mutation_screen.load_dna_strands(
		autobattler.ally_party[0].dna_strand, autobattler.enemy_party[0].dna_strand
	)


func _initiate_autobattler():
	pass
