/*[ Headband ]*/

// Radius of the circle that makes up the upper half of the headband
upperRadius = 60; // [20:120]
// This angle determines the size of the bottom half
bottomAngle = 35; // [0:120]
// Radius of the partial circles of the bottom half
bottomRadius = 120; // [20:600]
// Radius of the end bits at the very bottom
endRadius = 10; // [0:50]

// Height of the headband
height = 6; // [0:0.1:30]
// Width of the headband
width = 2.7; // [0:0.1:30]

/*[ Ears ]*/

// Where the ears are located on the headband
earPositionAngle = 37; // [0:90]

// Radius of the curvature of the ears sides
earRadius = 100; // [10:500]
// Roughly the length of the ears
earLength = 46; // [10:500]
// The width of the ears
earWidth = 44; // [10:120]
// Radius of the ears tips. 0 for spiky ears
earTipRadius = 3; // [0:100]
// How big the angle of the ear tips is
earTipAngle = 90; // [0:180]

/*[ Spikes ]*/

// How much of the upper ring has spikes (in degrees)
spikesAngle = 70; // [0:90]
// How long the spikes are. Increase for more grip
spikeDepth = 1.2; // [0:0.1:10]
// How high the spikes are.
spikeHeight = 3; // [0:0.1:10]
// How high the spikes are at the tip.
spikeHeightEnd = 1.5; // [0:0.1:10]
// How wide the spikes are.
spikeWidth = 1.5; // [0:0.1:20]
// Spikes per cm
spikeDensity = 3; // [0.1:0.01:20]

module mirror_copy(vector)
{
	children();
	mirror(vector) children();
}

module angled_thing(r, angle, off = 0, h = height, smooth = false)
{
	if (smooth)
	{
		minkowski(10)
		{
			cylinder($fn = 9, h = 0.001, d = width - 0.001);
			translate([ -off, 0, 0 ])
			rotate_extrude(convexity = 10, $fa = 0.01, $fs = 1, angle = angle) translate([ r, 0, 0 ])
			square([ 0.001, h ], center = true);
		}
	}
	else
	{
		translate([ -off, 0, 0 ])
		rotate_extrude(convexity = 10, $fa = 0.01, $fs = 1, angle = angle) translate([ r, 0, 0 ])
		square([ width, h ], center = true);
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
	fullCircumference = 2 * 3.1415 * earRadius;
	angle = (earLength / fullCircumference) * 360.0;

	// earHeight = earRadius * sin(angle);
	earTipWidth = 2 * earTipRadius * sin(earTipAngle / 2);

	sideLength = 2 * earRadius * sin(angle / 2);
	sideAngle = asin((earWidth / 2 - earTipWidth / 2) / sideLength);
	earHeight = sideLength * cos(sideAngle);

	// translate([earWidth/2,0,0])
	mirror_copy([ 1, 0, 0 ]) union()
	{
		translate([ earWidth / 2, 0, 0 ])
		rotate([ 0, 0, -angle / 2 + sideAngle ])
		angled_thing(r = earRadius, angle = angle, off = earRadius);

		translate([ earTipWidth / 2, earHeight, 0 ])
		cylinder(d = width, h = height, $fn = 16, center = true);
		translate([ earTipWidth / 2, earHeight, 0 ])
		rotate([ 0, 0, 90 - earTipAngle / 2 ])
		angled_thing(r = earTipRadius, angle = earTipAngle / 2, off = earTipRadius);
	}
}

// The spike make sure you dont lose your ears
module spike()
{
	rotate([ 90, 0, 0 ])
	scale([ spikeWidth / spikeHeight, 1, 1 ])
	{
		cylinder($fn = 12, d1 = spikeHeight, h = spikeDepth, d2 = spikeHeightEnd, center = false);
		translate([ 0, 0, -width / 2 ])
		cylinder(d = spikeHeight, h = width / 2, center = false);
	}
}

mirror_copy([ 1, 0, 0 ])
{
	union()
	{
		// Upper half
		angled_thing(r = upperRadius, angle = 90);

		// Ear
		rotate([ 0, 0, earPositionAngle ])
		translate([ 0, cos((earWidth / (2 * 3.1415 * upperRadius)) * 360 / 2) * upperRadius, 0 ])
		ear();

		// Spikes
		distance = upperRadius * 2 * 3.1415 * (spikesAngle / 360);
		spikeDistance = 10 / spikeDensity;
		spikeAngleDistance = spikesAngle / (distance / spikeDistance);
		spikeAmount = floor(distance / spikeDistance);
		for (i = [0:1:spikeAmount])
		{
			rotate([ 0, 0, (0.5 + i) * spikeAngleDistance ])
			translate([ 0, upperRadius - width / 2, 0 ])
			spike();
		}

		// Lower half
		angled_thing(r = bottomRadius, angle = -bottomAngle, off = bottomRadius - upperRadius);

		// Bottom thing for some reason
		shift_angled(r = bottomRadius, angle = -bottomAngle, off = bottomRadius - upperRadius) rotate([ 0, 0, 180 ])
		{

			angled_thing(r = endRadius, angle = bottomAngle, off = endRadius);
			shift_angled(r = endRadius, angle = bottomAngle, off = endRadius)
			    cylinder(d = width, h = height, $fn = 16, center = true);
		}
	}
}
