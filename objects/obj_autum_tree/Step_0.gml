// Step event

if (!is_animating) {
    // Stay on frame 1
    image_index = 0;

    // Randomly start the animation (e.g., 1 in 100 chance each frame)
    if (irandom(299) == 0) {
        is_animating = true;
        image_index = 1;  // Start at frame 2
        image_speed = 3;  // Set animation speed (adjust as needed)
    }
} else {
    // Check if the animation has finished (i.e., reached frame 17)
    if (image_index >= 17) {
        is_animating = false;
        image_speed = 0;  // Stop the animation
        image_index = 0;  // Return to frame 1
    }
}
