/// @description Insert description here
// You can write your code in this editor
if (!variable_instance_exists(id, "aura_index")) {
    aura_index = 0; // Ensure it's initialized
}

if (!variable_instance_exists(id, "only_mirror")) {
    only_mirror=false; // Ensure it's initialized
}

if (is_hit){
	aura_index += image_speed;
	if (floor(aura_index >= 5)){
		aura_index = 0;
	}
}

