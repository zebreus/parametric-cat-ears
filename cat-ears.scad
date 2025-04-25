/*[ Headband ]*/

// Radius of the circle that makes up the upper half of the headband
upperRadius = 65; // [20:120]
// This angle determines the size of the upper half
upperAngle = 50; // [10:140]
// Radius of the circle that makes up the middle part of the headband
middleRadius = 60; // [20:120]
// This angle determines the size of the middle part of the headband
middleAngle = 30; // [0:90]
// This angle determines the size of the bottom half
bottomAngle = 55; // [0:120]
// Radius of the partial circles of the bottom half
bottomRadius = 97; // [20:600]
// Radius of the end bits at the very bottom
endRadius = 10; // [0:50]

// Height of the headband
height = 6; // [0:0.1:30]
// Width of the headband
width = 3.2; // [0:0.1:30]

/*[ Ears ]*/

// Where the ears are located on the headband
earPositionAngle = 40; // [0:90]

// Radius of the curvature of the ears sides
earRadius = 120; // [10:500]
// Roughly how the ears are
earLength = 50; // [10:500]
// The width of the ears
earWidth = 55; // [10:120]
// How wide the tip of the ear is
earTipWidth = 5; // [2:40]
// How big the angle of the ears base is
earConnectorRadius = 7; // [2:50]

/*[ Spikes ]*/

// How much of the upper ring has spikes (in degrees)
// Should be smaller than upperAngle otherwise spikes will be detached
spikesAngle = 80; // [0:120]
// How long the spikes are. Increase for more grip
spikeDepth = 2.5; // [0:0.1:10]
// How high the spikes are.
spikeHeight = 4; // [0:0.1:10]
// How high the spikes are at the tip.
spikeHeightEnd = 1.5; // [0:0.1:10]
// How wide the spikes are.
spikeWidth = 1.4; // [0:0.1:20]
// Spikes per cm
spikeDensity = 3; // [0.1:0.01:20]

/*[ Rudelblinken ]*/

// Enable support for a rudelblinken PCB
enableRudelblinken = false;

/*[ LED recess ]*/

// Where the recess for LED strips will be generated
recess = "none"; //["none", "full", "outside", "inside", "insideWithoutHeadband"]
headbandRecess = recess == "outside" || recess == "full" || recess == "inside";
outsideEarRecess = recess == "outside" || recess == "full";
insideEarRecess = recess == "inside" || recess == "full" || recess == "insideWithoutHeadband";


// How deep the recess should be
recessDepth = 1.2; // [0.0:0.01:5.0]
// How wide the recess should be
recessWidth = 3; // [0:0.1:20]

// Puch a hole into the base of the ears for for cables to the inside
cableHole = 0.0; // [0:0.1:10]
// If the cable hole should be open
cableHoleOpen = false;
// Make the cable hole extra big
cableHoleAspect = 1;

// Dont open this section
/*[ Other hacky options ]*/

// How good you are at hearing
hearingAbility = 2; // [0:1:10]

// Enable extra protection
protection = false;

// Secret section with a boring name
/*[ About ]*/

// If the headband should be horny
horny = false;

// This is required because I am too lazy to calculate the length
hornyRadius = 75; // [0:0.5:200]

// Another setting
hornyDiff = 0; // [-100:0.5:100]



/*[ Hidden ]*/
rudelblinken_board_height = 1;
rudelblinken_board_length = 34.2;

module mirror_copy(vector)
{
    children();
    mirror(vector) children();
}

// recessSide can be "outer" or "inner"
module angled_thing(r, angle, h = height, spikesAngle = 0, spikeOffset = 0, outsideRecess = false, insideRecess = false)
{
    outsideRecessDepth = outsideRecess ? recessDepth : 0;
    insideRecessDepth = insideRecess ? recessDepth : 0;

    outsideRecessWidth = outsideRecess ? recessWidth : 0;
    insideRecessWidth = insideRecess ? recessWidth : 0;

    translate([ -r, 0, 0 ])
    rotate_extrude(convexity = 10, $fa = 0.01, angle = angle)
    translate([ r, 0, 0 ])
    polygon([
        [width/2, h/2],
        // [width/2, h/2 - recessWidth/2],
        [width/2, min(h/2,outsideRecessWidth/2 + abs(outsideRecessDepth))],
        [width/2 - outsideRecessDepth, outsideRecessWidth/2],
        [width/2 - outsideRecessDepth, -outsideRecessWidth/2],
        [width/2, -outsideRecessWidth/2],
        [width/2, -h/2],
        [-width/2, -h/2],
        [-width/2, -insideRecessWidth/2],
        [-width/2 + insideRecessDepth, -insideRecessWidth/2],
        [-width/2 + insideRecessDepth, insideRecessWidth/2],
        [-width/2, min(h/2,insideRecessWidth/2 + abs(insideRecessDepth))],
        [-width/2, h/2]]);
    // square([ width, h ], center = true);

    // Spikes if requested
    spikesDirection = spikesAngle > 0 ? 1 : -1;
    spikesAngle = abs(spikesAngle);
    distance = r * 2 * PI * (spikesAngle / 360);
    spikeDistance = 10 / spikeDensity;
    spikeAngleDistance = spikesAngle / (distance / spikeDistance);
    spikeOffset = ((((0.5 * spikeDistance) -abs(spikeOffset) )% spikeDistance)+spikeDistance)%spikeDistance;
    spikeAngleOffset =  spikesAngle / (distance / spikeOffset);
    for (spikeAngle = [spikeAngleOffset:spikeAngleDistance:spikesAngle])
    {
        translate([ -r, 0, 0 ])
        rotate([ 0, 0, spikesDirection * spikeAngle])
        translate([ r - width / 2, 0, 0 ])
        rotate([0,0,-90])
        spike();
    }
    if (protection){
        spikesDirection = angle > 0 ? 1 : -1;
        spikesAngle = abs(angle);
        distance = r * 2 * PI * (spikesAngle / 360);
        spikeDistance = 10 / spikeDensity;
        spikeAngleDistance = spikesAngle / (distance / spikeDistance);
        spikeOffset = ((((0.5 * spikeDistance) -abs(spikeOffset) )% spikeDistance)+spikeDistance)%spikeDistance;
        spikeAngleOffset =  spikesAngle / (distance / spikeOffset);
        for (spikeAngle = [spikeAngleOffset:spikeAngleDistance:abs(angle)])
        {
            translate([ -r, 0, 0 ])
            rotate([ 0, 0, spikesDirection * spikeAngle])
            translate([ r - width / 2, 0, 0 ])
            translate([recessSide == "inner" ? 0 : width,0,0]) 
            rotate([0,0,recessSide == "inner" ? -90 : 90])
            spike();
        }
    }
}

module shift_angled(r = 0, angle = 0)
{
    translate([ -r, 0, 0 ])
    rotate([ 0, 0, angle ])
    translate([ r, 0, 0 ])
    children();
}

function dist(p1, p2) = sqrt(pow(p2[0] - p1[0], 2) + pow(p2[1] - p1[1], 2));


// module funny_beam(start_angle=45,length=50, r1=10, r2=20){

//     center_a = [r1*cos(start_angle),r1*sin(start_angle)];
//     center_b = [0 , length];

//     rr1 = r1+r2;
//     rr2 = r2;

//     d = dist(center_a, center_b);

//     // Find the point P2 which is the point where the line through the intersection points crosses the line between the circle centers
//     l = (rr1^2 - rr2^2 + d^2) / (2 * d);

//     // Distance from P2 to the intersection points
//     h = sqrt(rr1 ^ 2 - l ^ 2);

//     center_c = [
//         (l/d)*(center_b[0]-center_a[0]) - (h/d)*(center_b[1]-center_a[1]) + center_a[0],
//         (l/d)*(center_b[1]-center_a[1]) + (h/d)*(center_b[0]-center_a[0]) + center_a[1],
//     ];

//     angle_ca = atan2(center_c[1]-center_a[1], center_c[0]-center_a[0]);
//     angle_cb = atan2(center_c[1]-center_b[1], center_c[0]-center_b[0]);
//     angle_connection = start_angle + 180 - angle_ca;

//     mirror([1,0,0])
//     rotate([0,0,-start_angle]){
//     %angled_thing(r = r1, angle = angle_connection);
//     shift_angled(r = r1, angle = angle_connection)
//     mirror([1,0,0])
//     %angled_thing(r = r2, angle =  (360+angle_cb -angle_ca) %360);
//     }


// }
// funny_beam();

// A single ear. Centered
module ear(start_angle=0){
    r1=earConnectorRadius;
    r2=earRadius;

    earSideWidth = (earWidth - earTipWidth)/2;
    earSideHeight = earLength;
    earSideLength = sqrt(earSideWidth^2 + earSideHeight^2);

    earSideAngle = atan(earSideWidth/earSideHeight);

    start_angle = 90 - earSideAngle - start_angle;


    center_a = [r1*cos(start_angle),r1*sin(start_angle)];
    center_b = [0 , earSideLength];

    rr1 = r1+r2;
    rr2 = r2;

    d = dist(center_a, center_b);

    // Find the point P2 which is the point where the line through the intersection points crosses the line between the circle centers
    l = (rr1^2 - rr2^2 + d^2) / (2 * d);

    // Distance from P2 to the intersection points
    h = sqrt(rr1 ^ 2 - l ^ 2);

    center_c = [
        (l/d)*(center_b[0]-center_a[0]) - (h/d)*(center_b[1]-center_a[1]) + center_a[0],
        (l/d)*(center_b[1]-center_a[1]) + (h/d)*(center_b[0]-center_a[0]) + center_a[1],
    ];

    angle_ca = atan2(center_c[1]-center_a[1], center_c[0]-center_a[0]);
    angle_cb = atan2(center_c[1]-center_b[1], center_c[0]-center_b[0]);
    angle_connection = start_angle + 180 - angle_ca;
    angle_side = (360+angle_cb -angle_ca) %360;
    angle_tip = 90-(angle_side + start_angle - angle_connection)-earSideAngle;

    tip_radius = earTipWidth /2 / sin(angle_tip) ;

    mirror_copy([1,0,0])
    translate([earWidth/2,0,0])
    rotate([0,0,earSideAngle])
    mirror([1,0,0])
    rotate([0,0,-start_angle]){
      // Attachment of ear to headband -- base-only section for leading wires/LED strip through
      difference(){
      union(){
        angled_thing(r=r1, angle = angle_connection, insideRecess = outsideEarRecess, outsideRecess = insideEarRecess);
        shift_angled(r = r1, angle = angle_connection)
        mirror([1,0,0]){
          // side
          angled_thing(r = r2, angle = angle_side, insideRecess = insideEarRecess, outsideRecess = outsideEarRecess);
          // tip
          shift_angled(r = r2, angle = angle_side )
          angled_thing(r = tip_radius, angle = angle_tip, spikeOffset = r1 * sin(angle_side), insideRecess = insideEarRecess, outsideRecess = outsideEarRecess);
        }
      }
      
      headbandRecessDepth = (headbandRecess ? recessDepth : 0);
      translate([-width/2 + headbandRecessDepth,0,0]){
      scale([cableHoleAspect,1,1]) {
      rotate([-90,0,0])
      cylinder(h = 1000, r=cableHole/2, $fn=16);
      
      translate([-cableHole/2,0,0])
      cube([cableHole,1000,10] * (cableHoleOpen ? 1 : 0));

      translate([-cableHole/2,0,0])
      rotate([0,headbandRecessDepth != 0 ? -asin( (headbandRecessDepth/cableHoleAspect)/ (height/2)) : 0,0])
      cube([cableHole,1000,10] * (cableHoleOpen ? 1 : 0));
      }
      }
      }
    }
}

// A single ear. Centered
module horn(start_angle=0){
    r1=earConnectorRadius;
    r2=earRadius;

    earSideWidth = (earWidth - earTipWidth)/2;
    earSideHeight = earLength;
    earSideLength = sqrt(earSideWidth^2 + earSideHeight^2);

    earSideAngle = atan(earSideWidth/earSideHeight);

    start_angle = 90 - earSideAngle - start_angle;


    center_a = [r1*cos(start_angle),r1*sin(start_angle)];
    center_b = [0 , earSideLength];

    rr1 = r1+r2;
    rr2 = r2;

    d = dist(center_a, center_b);

    // Find the point P2 which is the point where the line through the intersection points crosses the line between the circle centers
    l = (rr1^2 - rr2^2 + d^2) / (2 * d);

    // Distance from P2 to the intersection points
    h = sqrt(rr1 ^ 2 - l ^ 2);

    center_c = [
        (l/d)*(center_b[0]-center_a[0]) - (h/d)*(center_b[1]-center_a[1]) + center_a[0],
        (l/d)*(center_b[1]-center_a[1]) + (h/d)*(center_b[0]-center_a[0]) + center_a[1],
    ];

    angle_ca = atan2(center_c[1]-center_a[1], center_c[0]-center_a[0]);
    angle_cb = atan2(center_c[1]-center_b[1], center_c[0]-center_b[0]);
    angle_connection = start_angle + 180 - angle_ca;
    angle_side = (360+angle_cb -angle_ca) %360;
    angle_tip = 90-(angle_side + start_angle - angle_connection)-earSideAngle;

    tip_radius = earTipWidth /2 / sin(angle_tip) ;

    intersection() {
    translate([0,0,-50])
    cylinder(h= 100, r=hornyRadius);

    union() {
    translate([earWidth/2,0,0]) 
    rotate([0,0,earSideAngle])
    mirror([1,0,0])
    rotate([0,0,-start_angle]){
    angled_thing(r = r1, angle = angle_connection, recessSide = "inner", insideRecess = outsideEarRecess, outsideRecess = insideEarRecess);
    shift_angled(r = r1, angle = angle_connection)
    mirror([1,0,0]){
    mirror([1,0,0])
    angled_thing(r = r2-hornyDiff, angle =  180, insideRecess = outsideEarRecess, outsideRecess = insideEarRecess);
    }
    }
    
    mirror([1,0,0])
    translate([earWidth/2,0,0]) 
    rotate([0,0,earSideAngle])
    mirror([1,0,0])
    rotate([0,0,-start_angle]){
    angled_thing(r = r1, angle = angle_connection, recessSide = "inner", insideRecess = outsideEarRecess, outsideRecess = insideEarRecess);
    shift_angled(r = r1, angle = angle_connection)
    mirror([1,0,0]){
    angled_thing(r = r2, angle =  180, insideRecess = insideEarRecess, outsideRecess = outsideEarRecess);
    }
    }
    }
    }
}

module lower_half(enableRudelblinken = enableRudelblinken) {
     // Main beam until the rudelblinke board
    angled_thing(r = bottomRadius, angle = min(0,-bottomAngle + rudelblinken_board_angle_length), outsideRecess = headbandRecess);

    bottom_circumference = bottomRadius * 2 * PI;
    rudelblinken_board_angle_length = enableRudelblinken ? (360 * (rudelblinken_board_length / bottom_circumference)) : 0;
    shift_angled(r = bottomRadius, angle = -bottomAngle + rudelblinken_board_angle_length)
    if (enableRudelblinken){
    second_lower_half_with_rudelblinken();
    }else {

    second_lower_half_without_rudelblinken(angle = rudelblinken_board_angle_length);
    }
}

// The bottom part of the headband with a slot for a rudelblinken board
module second_lower_half_with_rudelblinken() {
     // Main beam until the rudelblinke board
    bottom_circumference = bottomRadius * 2 * PI;
    rudelblinken_board_angle_length = 360 * (rudelblinken_board_length / bottom_circumference);
    difference() {
        hull() 
        {
            shift_angled(r = bottomRadius, angle = -rudelblinken_board_angle_length)
            round_end_thing();
            angled_thing(r = bottomRadius, angle = -rudelblinken_board_angle_length, outsideRecess = headbandRecess);
            rotate([ 180, 0, 0 ])
            rotate([ 0, 90, 0 ]){
                rudelblinken(h = width, extra_length = true);
                translate([-0.5,0,0])
                rudelblinken(h = width, extra_length = true);
            }
        }
                
        // Subtract the inner part of the hull that gets filled by the hull operation above
        translate([-bottomRadius,0,0]) 
        cylinder($fs= 1,$fa=0.1,h = height*10, r = bottomRadius-(width/2), center = true);

        board_height_with_recess = rudelblinken_board_height + recessDepth;

        // Subtract the actual rudelblinken PCB
        rotate([ 180, 0, 0 ])
        rotate([ 0, 90, 0 ])
        translate([0,0, width / 2 - board_height_with_recess /2]){
        rudelblinken(h = board_height_with_recess + 0.01);
        // Dirty hack to have no overhang, when the pcb is slimmer than height
        translate([0.01,0,0]) 
        rudelblinken(h = board_height_with_recess + 0.01);
        }
        
        // USB c port cutout
        translate([width / 2 - recessDepth,-rudelblinken_board_length-20+0.1,-2.1]){
            translate([-0.5,0,1.25]) 
            cube([20,20,6.5]);
            translate([1,0,-0.25]) 
            cube([20,20,9.5]);
            translate([1,0,1.25]) 
            rotate([-90,0,0])
            cylinder(h=20,d=3,$fn=20);
            translate([1,0,7.75]) 
            rotate([-90,0,0])
            cylinder(h=20,d=3,$fn=20);
        }

    }
}

// The bottom part of the headband with a slot for a rudelblinken board
module second_lower_half_without_rudelblinken(angle) {
    shift_angled(r = bottomRadius, angle = -angle)
    round_end_thing();
    angled_thing(r = bottomRadius, angle = -angle, outsideRecess = headbandRecess);
}


// The thing at the very end of the headband
module round_end_thing() {
    rotate([ 0, 0, 180 ])
    {
        angled_thing(r = endRadius, angle = bottomAngle, insideRecess = headbandRecess);
        shift_angled(r = endRadius, angle = bottomAngle)
        cylinder(d = width, h = height, $fn = 16, center = true);
    }
}

// The spike make sure you dont lose your ears
module spike()
{
    rotate([ 90, 0, 0 ]) scale([ spikeWidth / spikeHeight, 1, 1 ])
    {
        cylinder($fn = 9, d1 = spikeHeight, h = spikeDepth, d2 = spikeHeightEnd, center = false);
        translate([ 0, 0, -width / 2 ]) cylinder(d = spikeHeight, h = width / 2, center = false);
    }
}



module rudelblinken_shape(center = true, extra_length = false)
{
    if (extra_length) {
    translate([ -2.5,0,0 ]) polygon([
        [ 0, 0 ],
        [ 5, 0 ],
        [ 5, -5 ],
        [ 5.7, -5 ],
        // [ 5, 5.2 ],
        // [ 6.5, 6.2 ],
        [ 10.5, 11.4 ],
        [ 10.1, 13.4 ],
        [ 10.1, 14.4 ],
        [ 10.1, 34.5 ],
        [ 0, 34.5 ],
    ]);
    } else {
         translate([ -2.6,0,0 ]) polygon([
        [ 0, -5 ],
        [ 5.3, -5 ],
        [ 5.3, 0 ],
        // [ 5, 5.2 ],
        // [ 6.5, 6.2 ],
        [ 10.6, 13.4 ],
        [ 10.3, 34.5 ],
        [ 0, 34.5 ],
    ]);
    }
}
module rudelblinken(h = rudelblinken_board_height, center = true, extra_length = false)
{
    translate([ 0, 0, center ? -h / 2 : 0 ]) linear_extrude(height = h)
        rudelblinken_shape(center, extra_length);
}


for(side = ["right", "left"])
mirror([side == "left" ? 1 : 0,0,0])
translate([0,upperRadius,0])
rotate([0,0,90])
{
    angled_thing(r = upperRadius, angle = -upperAngle, spikesAngle = -min(spikesAngle, upperAngle), outsideRecess = headbandRecess);
    shift_angled(r = upperRadius, angle = -upperAngle){
        angled_thing(r = middleRadius, angle = -middleAngle, spikesAngle = -min(max(spikesAngle-upperAngle, 0), middleAngle, spikeOffset = (upperAngle/upperRadius)*2*PI*upperRadius), outsideRecess = headbandRecess);
        shift_angled(r = middleRadius, angle = -middleAngle)
        lower_half(enableRudelblinken = (enableRudelblinken && (side=="left")));
    }

    relevant_angle = ((earWidth / 2)/(2*PI*upperRadius)) * 360;
    relevant_length = upperRadius - sqrt( upperRadius^2 - (earWidth/2)^2);
    // echo(relevant_angle);
    // echo(relevant_length);
    if (hearingAbility >= 1){
        earStartPosition = hearingAbility <= 1 ? 0 : earPositionAngle;
        earDistance = earPositionAngle*2 / (hearingAbility - 1);
        for(earPosition = [-earStartPosition:earDistance:0])
        shift_angled(r = upperRadius, angle = -earPosition)
        translate([-relevant_length,0,0]) 
        rotate([0,0,-90])
        if(horny){
            horn(start_angle = relevant_angle);
        } else {
            ear(start_angle = relevant_angle);
        }
    }
}

