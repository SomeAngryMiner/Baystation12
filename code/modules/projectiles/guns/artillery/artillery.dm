/obj/item/gun/projectile/artillery
	name = "laser-guided recoilless launcher"
	desc = "This is a Terraphistus Armor RCL-12 CDIA heavy recoilless launcher, accepted into SCG service as the M207 METES. Designed for a two-man gunner team, this weapon is heavy, cumbersome, and lethal to untrained operators."
	icon = 'icons/obj/guns/recoilless_launcher.dmi'
	icon_state = "recoilless_launcher"
	item_state = "recoilless_launcher"
	wielded_item_state = "recoilless_launcher-wielded"
	safety_icon = "recoilless-safety"
	force = 20 // This is, understandably, huge
	bulk = GUN_BULK_RIFLE + 3
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	caliber = CALIBER_HEAVY_SHELL
	screen_shake = 2 //
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	ammo_type = /obj/item/ammo_casing/artillery/explosive
	one_hand_penalty = 8 // Firing a rocket launcher with one hand is ill-advised
	bulk = 8
	var/toggle_loader_sound = 'sound/weapons/guns/interaction/rpgoneuse_deploying.wav' //what sound does it do while opening?
	var/finish_loader_sound = 'sound/items/breaker_flip.ogg' //what sound does it make when it correctly finishes opening?
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	fire_sound = 'sound/weapons/gunshot/mech_autocannon.ogg'
	fire_delay = 20 // I would be surprised if you fire this faster than you can load it, but just in case
	var/open_loader = 0 //Checks if the launcher is open
	var/backblast = TRUE //Does this gun expel a plume of hot gas behind the user after its fired?

/obj/item/gun/projectile/artillery/on_update_icon()
	..()
	if(loaded && open_loader)
		AddOverlays(image(icon, "mag"))
	if(open_loader)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/gun/projectile/artillery/attack_self(mob/user as mob)
	open_loader = !open_loader
	if (open_loader) //loader's closed: let's open it!
		user.visible_message(
			SPAN_ITALIC("\The [user] starts opening up \the [src]..."),
			SPAN_ITALIC("You start opening up \a [src]..."),
			SPAN_ITALIC("You hear the rustle of metal and plastic.")
		)
		playsound(src, toggle_loader_sound, 50, 1)
		if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			return FALSE
		playsound(src, finish_loader_sound, 50, 1)
	else //loader's open: let's close it!
		user.visible_message(
			SPAN_ITALIC("\The [user] starts closing up \the [src]..."),
			SPAN_ITALIC("You start closing up \a [src]..."),
			SPAN_ITALIC("You hear the rustle of metal and plastic.")
		)
		playsound(src, toggle_loader_sound, 50, 1)
		if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			return FALSE
		if (length(loaded))
			chambered = loaded[1]
		else
			chambered = null
		playsound(src.loc, finish_loader_sound, 50, 1)
		open_loader = 0
	add_fingerprint(user)
	update_icon()
	return TRUE

/obj/item/gun/projectile/artillery/special_check(mob/user) //did you forget to close the loading hatch?
	if(open_loader)
		to_chat(user, SPAN_WARNING("You can't fire \the [src] while the loading port is open!"))
		return 0
	return ..()

/obj/item/gun/projectile/artillery/load_ammo(mob/user) //don't load ammo if the loader is closed
	if(!open_loader)
		to_chat(user, SPAN_WARNING("You can't load \the [src] while the loading port is closed."))
		return
	..()

/obj/item/gun/projectile/artillery/unload_ammo(mob/user, allow_dump=1) //don't unload ammo if the loader is closed either
	if(!open_loader)
		to_chat(user, SPAN_WARNING("You can't unload \the [src] while the loading port is closed."))
		return
	..()

/obj/item/gun/projectile/artillery/handle_post_fire(mob/user)
	..()
	if (backblast) //does this weapon have a considerable backblast?
		var/backblast_location = get_turf(get_step(user.loc, reverse_direction(user.dir))) //select the zone behind the shooter...
		var/datum/effect/smoke_spread/bad/smoke = new
		smoke.set_up(2, 0, backblast_location, turn(user.dir, 180)) //create smoke, make it go in the opposite direction of shooter's facing direction
		smoke.start() //create that smoke!
		for(var/mob/living/victim in backblast_location) //is anyone foolish enough to stand behind the shooter?

			victim.apply_damage(40, DAMAGE_BRUTE, used_weapon = "Overpressure concentration", armor_pen=25) // This damage is hardly avoidable, even with armor

			victim.apply_damage(60, DAMAGE_BURN, used_weapon = "Thermal blast") // this one, however, you can mitigate with proper equipment. Still shouldn't stand there though.

			victim.flash_eyes() //First sign you're cooked

			victim.visible_message(
				SPAN_DANGER("\The [victim] gets washed over by a plume of smoke and sparks!"),
				SPAN_DANGER("In a fraction of a second, you feel yourself washed over by a scorching heat, and violently thrown back!"),
				SPAN_DANGER("You hear sickening sizzling, and a loud bang.")
			)

			victim.throw_at(get_edge_target_turf(victim, get_dir(src, victim)), rand(1,3), 4) // Throw them away - even in power armor, you're not immune to physics.

			victim.Stun(rand(3,5)) // You're getting hit by an overpressurized blast of super hot, high pressure gas - This knocks out people, naturally

			victim.ear_damage += rand(0, 5) // Your ears did not like that - deafen them. Akin to a close flashbang
			victim.ear_deaf = max(victim.ear_deaf,15)

			victim.apply_effect(8, EFFECT_EYE_BLUR) //mild after effects, but you're still alive, that's lucky enough