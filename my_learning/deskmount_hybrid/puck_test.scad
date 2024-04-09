include <../../dactyl-deskmount/geometry.scad>
use <../../dactyl-deskmount/parts/placeholders/tee-nut.scad>

mount_base_height = 8.5;

thumb_arm_base = [-20, -10, 5];
difference() {
    union() {
        rotate([0, 0, -70]) cylinder(d=28, h=mount_base_height);
        color("mediumseagreen") union() {
            hull() {
                rotate([0, 0, 190]) arc(r1=14, r2=12, h=mount_base_height, a=70);
                translate(thumb_arm_base) sphere(r=4.5);
            }
        }
    }
    tee_nut($clearance=1, footprint=true);
}