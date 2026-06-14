class_name Autobattler extends Node


func find_typed_children(parent: Node, pattern: String, type: StringName) -> Array:
	var found = parent.find_children(pattern, type)
	var untyped: Array = []
	untyped.append_array(found) 
	return untyped

@onready var enemy_party: Array[PartyMember] = find_typed_children(%AllyPartyMembers, "PartyMember?", "PartyMember")
@onready var ally_party: Array[PartyMember] = find_typed_children(%EnemyPartyMembers, "PartyMember?", "PartyMember")
@onready var turn_order: Array[PartyMember] = enemy_party + ally_party

func sort_speed(a: PartyMember, b: PartyMember):
	if a.speed < b.speed:
		return true
	return false

func _ready() -> void:
	turn_order.sort_custom(sort_speed)

func _auto_battle() -> void:
	for party_member in turn_order:
		if party_member.dead:
			turn_order.erase(char)
			continue
		party_member.do_turn()
