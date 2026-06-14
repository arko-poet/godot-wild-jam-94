class_name Autobattler extends Node

var enemy_party: Array[PartyMember]
var ally_party: Array[PartyMember]
@onready var turn_order: Array[PartyMember] = enemy_party + ally_party

func sort_speed(a: PartyMember, b: PartyMember):
	if a.speed < b.speed:
		return true
	return false

func _ready() -> void:
	#Need to set turn_order list
	turn_order.sort_custom(sort_speed)

func _auto_battle() -> void:
	for party_member in turn_order:
		if party_member.dead:
			turn_order.erase(char)
			continue
		party_member.do_turn()
