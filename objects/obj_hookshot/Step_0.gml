// Keep the chain connected to the player
x_start = owner.x;
y_start = owner.y;

// Move hookshot towards target (only if not returning and not attached)
if (!hook_attached && !hook_returning) {
    var dir = point_direction(x_start, y_start, target_x, target_y);
    x += lengthdir_x(5, dir);
    y += lengthdir_y(5, dir);
    // Update hook_distance based on actual movement
    hook_distance = point_distance(x_start, y_start, x, y);

    // Check if hookshot reaches max range without hitting anything
    if (hook_distance >= max_distance) {
        show_debug_message("Hook returning!");
        hook_returning = true; // Start returning to player

        // Store return direction ONCE so it doesn't change mid-retraction
        return_dir = point_direction(x, y, owner.x, owner.y);
    }

    // Check for collisions with solid objects
    if (place_meeting(x, y, obj_autum_tree)) {
        hook_attached = true;
		
        show_debug_message("Hook attached!");
    }
}

// If the hookshot is returning to the player
if (hook_returning) {
    // Ensure return_dir is properly assigned ONCE
    if (!variable_instance_exists(id, "return_dir")) {
        return_dir = point_direction(x, y, owner.x, owner.y);
    }

    show_debug_message("return_dir " + string(return_dir));

    // Move back towards the player using the stored direction
    direction = point_direction(x,y, x_start ,y_start);

    // Update hook_distance while retracting
    hook_distance = point_distance(x, y, owner.x, owner.y);
    show_debug_message("hook_distance " + string(hook_distance));

    // If the hook reaches the player, remove it
    if (hook_distance <=5) {
        show_debug_message("Hook retracted!");
        instance_destroy();
        owner.hook_active = false;
    }
}

if (hook_attached) {

    // Reduce hook_distance to create the retracting effect
    hook_distance = point_distance(x, y, owner.x, owner.y);
    
    // If close enough, destroy the hook and reset hookshot state
    if (hook_distance <=5) {
        instance_destroy(); // Destroy the hookshot object
        owner.hook_active = false; // Reset hook state in player
    }
}
