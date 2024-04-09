use <../../dactyl-deskmount/parts/placeholders/tee-nut.scad>
use <../../dactyl-deskmount/parts/placeholders/m3-hex-nut.scad>
use <../../dactyl-deskmount/scad-utils/linalg.scad>
use <../../dactyl-deskmount/scad-utils/lists.scad>
use <../../dactyl-deskmount/scad-utils/shapes.scad>
use <../../dactyl-deskmount/scad-utils/spline.scad>
use <../../dactyl-deskmount/scad-utils/transformations.scad>
use <../../dactyl-deskmount/debug-helpers.scad>
use <../../dactyl-deskmount/positioning.scad>
use <../../dactyl-deskmount/positioning-transformations.scad>
use <../../dactyl-deskmount/util.scad>

mount_base_height = 8.5;

/*index_arm_base = pasarlo como parametro;
index_arm_tip = ;
middle_arm_base = ;
middle_arm_tip = ;
top_ring_arm_base = ;
top_ring_arm_tip = ;
pinkie_arm_base = ;
pinkie_arm_tip = ;*/

steps = 6;
profiles = [for (t=[0:steps]) circle(pow((1 - t/steps), 2) * 0.5 + 4, $fn=12)];
/*    
zero = [0,0,0,1];*/
    
module screw_and_nut_cutout() {
  translate([0, 0, 5]) cylinder(d=6.5, h=3);
  translate([0, 0, -1]) cylinder(d=3, h=6);
  scale([1, 1, 2]) translate([0, 0, -2]) m3_hex_nut($clearance=1);
  m3_hex_nut($clearance=.75);
}

bezier_sweep( [[-20, -10, 5, 1], [-1, 0, 0], [-64.7701, -34.9103, 15.5917, 1]
, [1, 10, 0] ], debug=true);

module bezier_sweep(control_points, debug=false) {
  control_points = [ for (v=control_points) take3(v) ];
  bezier = bezier3_args(control_points, symmetric=true);
  total = len(bezier);
  steps = len(profiles) - 1;
  step = total / steps;

  if (debug) {
    for (i=[0:2:len(control_points)-2]) {
      color("gold") translate(control_points[i]) sphere(r=3);
      color("blue", alpha=0.4) translate(control_points[i]) vector(control_points[i+1]);
    }
    for(t=[0:0.05:len(bezier)]) translate(spline(bezier, t))
      sphere(r=0.25, $fn=4);
  }

  color(alpha=debug ? 0.4 : 1)
  for (t=[0:steps - 1])
  serial_hulls() {
    multmatrix(spline_transform(bezier, step * (t+0))) linear_extrude(height=0.1) polygon(profiles[t+0]);
    multmatrix(spline_transform(bezier, step * (t+1))) linear_extrude(height=0.1) polygon(profiles[t+1]);
  }
}
    
module mount_base(){
    difference() {
        rotate([0, 0, 0]) cylinder(d=28, h=mount_base_height);
        tee_nut($clearance=1, footprint=true);
    }
}