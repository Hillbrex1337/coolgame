/// Create Event of obj_party_member

// Initialize the party member's name and sprite (these will be set externally when the object is created)
name = "";
key = "";
sprite_index = noone;
original_x = 0;
original_y = 0;
is_player = false;
record = 0;
original_sprite="";
is_ready = false;
attack_speed = 1;
ready_meter = 0;  // To store the meter progress for each party member
array_push(obj_battle_menu.party_members, self);