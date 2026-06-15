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

@onready var ally_stats: Stats = %AllyStats
@onready var enemy_stats: Stats = %EnemyStats

func _ready() -> void:
	print("party members in turn order")
	print(turn_order.size())
	ally_stats.init_stats(ally_party[0].strength
	,ally_party[0].health
	,ally_party[0].speed)

	enemy_stats.init_stats(enemy_party[0].strength
	,enemy_party[0].health
	,enemy_party[0].speed)

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
			var target_stats: Stats
			if party_member in ally_party:
				target_player = enemy_party[0]
				target_stats = enemy_stats
				if target_player.dead:
					enemy_party.erase(target_player)
					turn_order.erase(target_player)
					continue
			else:
				target_player = ally_party[0]
				target_stats = ally_stats
				if target_player.dead:
					ally_party.erase(target_player)
					turn_order.erase(target_player)
					continue


			party_member.target_player = target_player
			party_member.do_turn(%CombatLog, target_stats)
