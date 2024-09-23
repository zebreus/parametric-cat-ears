upper_radius = 60;

height = 6;
width = 2.7;

bottom_angle = 30;

end_radius = 10;

ear_position_angle = 37;

ear_radius = 100;
ear_length = 46;
ear_width = 44;

ear_tip_radius = 4;
ear_tip_angle = 80;

spike_height = height / 2;
spike_height_end = height / 4;
spike_depth = 1.2;
spike_width = 1.5;
// Spikes per cm
spike_density = 3;
// How much of the upper ring is spiked
spikes_angle = 70;

module mirror_copy(vector)
{
	children();
	mirror(vector) children();
}

module angled_thing(r, angle, off = 0, h = height)
{
	minkowski(10)
	{
		cylinder($fn = 9, h = 0.001, d = width - 0.001);
		translate([ -off, 0, 0 ])
		rotate_extrude(convexity = 10, $fa = 0.01, $fs = 1, angle = angle) translate([ r, 0, 0 ])
		square([ 0.001, h ], center = true);
	}
}

module shift_angled(r = 0, angle = 0, off = 0)
{
	translate([ -off, 0, 0 ])
	rotate([ 0, 0, angle ])
	translate([ r, 0, 0 ])
	children();
}

// A single ear. Centered
module ear()
{
	full_circumference = 2 * 3.1415 * ear_radius;
	angle = (ear_length / full_circumference) * 360.0;

	// ear_height = ear_radius * sin(angle);
	ear_tip_width = 2 * ear_tip_radius * sin(ear_tip_angle / 2);

	side_length = 2 * ear_radius * sin(angle / 2);
	side_angle = asin((ear_width / 2 - ear_tip_width / 2) / side_length);
	ear_height = side_length * cos(side_angle);

	// translate([ear_width/2,0,0])
	mirror_copy([ 1, 0, 0 ])
	{
		translate([ ear_width / 2, 0, 0 ])
		rotate([ 0, 0, -angle / 2 + side_angle ])
		angled_thing(r = ear_radius, angle = angle, off = ear_radius);

		translate([ ear_tip_width / 2, ear_height, 0 ])
		rotate([ 0, 0, 90 - ear_tip_angle / 2 ])
		angled_thing(r = ear_tip_radius, angle = ear_tip_angle / 2, off = ear_tip_radius);
	}
}

// The spike make sure you dont lose your ears
module spike()
{
	rotate([ 90, 0, 0 ])
	scale([ spike_width / spike_height, 1, 1 ])
	{
		cylinder($fn = 12, d1 = spike_height, h = spike_depth, d2 = spike_height_end, center = false);
		translate([ 0, 0, -width / 2 ])
		cylinder(d = spike_height, h = width / 2, center = false);
	}
}

mirror_copy([ 1, 0, 0 ])
{
	union()
	{
		// Upper half
		angled_thing(r = upper_radius, angle = 90);

		// Ear
		rotate([ 0, 0, ear_position_angle ])
		translate([ 0, cos((ear_width / (2 * 3.1415 * upper_radius)) * 360 / 2) * upper_radius, 0 ])
		ear();

		// Spikes
		distance = upper_radius * 2 * 3.1415 * (spikes_angle / 360);
		spike_distance = 10 / spike_density;
		spike_angle_distance = spikes_angle / (distance / spike_distance);
		spike_amount = floor(distance / spike_distance);
		for (i = [0:1:spike_amount])
		{
			rotate([ 0, 0, (0.5 + i) * spike_angle_distance ])
			translate([ 0, upper_radius - width / 2, 0 ])
			spike();
		}

		// Lower half
		angled_thing(r = upper_radius * 2, angle = -bottom_angle, off = upper_radius);

		// Bottom thing for some reason
		shift_angled(r = upper_radius * 2, angle = -bottom_angle, off = upper_radius) rotate([ 0, 0, 180 ])
		angled_thing(r = end_radius, angle = bottom_angle, off = end_radius);
	}
}
