/obj/item/gun/projectile/artillery
	name = "parent artillery weapon"
	desc = "you shouldn't be seeing this, MAGGOT."
	icon = 'icons/obj/guns/missile.dmi'
	icon_state = "missile_launcher"
	item_state = "missile_launcher"
	force = 20 // This is, understandably, huge
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	handle_casings = CLEAR_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	caliber = CALIBER_PORTABLE_MISSILE
	screen_shake = 2 //
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	ammo_type = /obj/item/ammo_casing/missile
	one_hand_penalty = 8 // Firing a rocket launcher with one hand is ill-advised
	bulk = 8
	wielded_item_state = "missile_launcher-wielded"
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
	if (open_loader)
		user.visible_message(
			SPAN_ITALIC("\The [user] starts opening up \the [src]..."),
			SPAN_ITALIC("You start opening up \a [src]..."),
			SPAN_ITALIC("You hear the rustle of metal and plastic.")
		)
		playsound(src, toggle_loader_sound, 50, 1)
		if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			return FALSE
		playsound(src, finish_loader_sound, 50, 1)
	else
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

/obj/item/gun/projectile/artillery/special_check(mob/user)
	if(open_loader)
		to_chat(user, SPAN_WARNING("You can't fire \the [src] while the loading port is open!"))
		return 0
	return ..()

/obj/item/gun/projectile/artillery/load_ammo(obj/item/A, mob/user)
	if(!open_loader)
		return
	..()

/obj/item/gun/projectile/artillery/unload_ammo(mob/user, allow_dump=1)
	if(!open_loader)
		return
	..()

/obj/item/gun/projectile/artillery/handle_post_fire()
	..()
	if (backblast)
		var/datum/effect/smoke_spread/smoke = new
		smoke.set_up(5, 0, get_step(src.loc, reverse_direction(src.dir)))
		smoke.start()