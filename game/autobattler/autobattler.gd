class_name Autobattler extends Node

signal autobattle_finished

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

@onready var ally_stats: StatsScene = %AllyStats
@onready var enemy_stats: StatsScene = %EnemyStats

@onready var overlay: CanvasLayer = $Overlay
var party_member: PartyMember

func _ready() -> void:
	print("party members in turn order")
	print(turn_order.size())

	enemy_stats.init_stats(enemy_party[0].stats, enemy_party[0].member_name)


## TODO game controller will have to create enemies and pass them here
#func set_creatures(ally: PartyMember, enemy: PartyMember = null) -> void:
	#ally_party.append(ally)
	#ally_stats.init_stats(ally_party[0].stats, ally_party[0].member_name)
	#party_member = ally


## shows/hides scene DEPRECATED
#func switch_scene(on := true) -> void:
	#for child in get_children():
		#if child is Control:
			#if on:
				#child.show()
			#else:
				#child.hide()
	#for child in overlay.get_children():
		#if child is Control:
			#if on:
				#child.show()
			#else:
				#child.hide()


func auto_battle() -> void:
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
				if target_player.dead:
					enemy_party.erase(target_player)
					turn_order.erase(target_player)
					continue
			else:
				target_player = ally_party[0]
				if target_player.dead:
					ally_party.erase(target_player)
					turn_order.erase(target_player)
					continue

			party_member.target_player = target_player
			await get_tree().create_timer(1.0).timeout # TODO band aid to be remove
			party_member.do_turn(%CombatLog)
			
	autobattle_finished.emit()
