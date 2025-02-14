// Array to store key collision points (origin, mirrors, objects)
beam_path = [];  

// Tracking variables
moving = true;
target = noone;
reflected = false;
max_distance = 1500;  // Maximum beam range
beam_length = 0;

repelling = false;