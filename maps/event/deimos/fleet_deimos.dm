#include "fleet_deimos_shuttle.dm"

/datum/map_template/ruin/fleet_deimos
	name = "SFV Deimos"
	id = "fleet_deimos"
	description = "A medium sized shuttlecraft in solar fleet colors transmitting the tag 'THARION-45 DEIMOS'. Scans indicate it is a Saint-class transport shuttle with minimal lifesigns aboard."
	suffixes = list("maps/event/deimos/fleetyatch.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/fleet_deimos)

/obj/effect/overmap/visitable/sector/fleet_deimos_spawn
	name = "Sensor Anomaly"
	desc = "A shuttle bearing the designation of 'SFV THARION-45 DEIMOS' is drifting at a slow sublight speed here. Preliminary scans detected irregularities in hull integrity. Damage source impossible to triangulate."
	in_space = TRUE
	icon_state = "event"
	hide_from_reports = TRUE

/obj/effect/overmap/visitable/ship/landable/fleet_deimos
	name = "SFV Deimos"
	desc = "A medium sized shuttlecraft in solar fleet colors transmitting the tag 'THARION-45 DEIMOS'. Scans indicate it is a Saint-class transport shuttle with minimal lifesigns aboard."
	shuttle = "SFV Deimos"
	icon_state = "ship"
	moving_state = "ship_moving"
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	vessel_mass = 1
	known = FALSE
	initial_generic_waypoints = list(
		"nav_fleet_deimos_deckbridgebow",
		"nav_fleet_deimos_deckbridgestern",
		"nav_fleet_deimos_deck1bow",
		"nav_fleet_deimos_deck1stern",
		"nav_fleet_deimos_deck2bow",
		"nav_fleet_deimos_deck2stern",
		"nav_fleet_deimos_deck3bow",
		"nav_fleet_deimos_deck3stern",
		"nav_fleet_deimos_deck4bow",
		"nav_fleet_deimos_deck4stern",
		"nav_fleet_deimos_offship"
	)

/area/map_template/fleet_deimos
	name = "\improper SFV Deimos"
	icon_state = "blue"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_bearcat)


//items

/obj/item/card/id/deimos
	access = list(access_bearcat)