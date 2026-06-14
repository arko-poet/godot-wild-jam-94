class_name Autobattler extends Node

func find_party_members(parent: Node, pattern: String) -> Array[PartyMember]:
	var found = parent.find_children(pattern, "PartyMember")
	var untyped: Array = []
	untyped.append_array(found) 
	var party_members: Array[PartyMember] = []
	party_members.assign(untyped)
	
	return party_members

@onready var enemy_party: Array[PartyMember] = find_party_members(%EnemyPartyMembers, "PartyMember")
@onready var ally_party: Array[PartyMember] = find_party_members(%AllyPartyMembers, "PartyMember")
@onready var turn_order: Array[PartyMember] = enemy_party + ally_party

func _ready() -> void:
	print("party members in turn order")
	print(turn_order.size())
	_auto_battle()

func _auto_battle() -> void:
	while not enemy_party.is_empty() and not ally_party.is_empty():
		for party_member in turn_order:
			if party_member.dead:
				turn_order.erase(party_member)
				if party_member in ally_party:
					ally_party.erase(party_member)
				else:
					enemy_party.erase(party_member)
				continue

			var target_player: PartyMember
			if party_member in ally_party:
				target_player = enemy_party[0]
			else:
				target_player = ally_party[0]

			party_member.target_player = target_player
			party_member.do_turn()
