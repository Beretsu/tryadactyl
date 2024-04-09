use <../../settings.scad>;
use <../../key/cap.scad>;
use <../../column/util.scad>;
use <../../column/layout.scad>;
use <../../assembly/util.scad>;
use <../../key/mount.scad>;
use <../../util.scad>;

rows=4;
cols=2;

homerow=2;
profile_rows=effective_rows(rows,homerow);
tilt=[-3,0,0];
tent=[0,32,0];
row_chord = [14.5,25,0];
/*first index, middle and ring translation away from center,cylindrical part of the keyboard it appears*/
// Akko cherry PBT neesds a bit more space
tight_cylindrical_row =[row_chord+[.5/2,0,0],
			 row_chord+[.5,0,0],
			 row_chord,/*trackpoint*/
			 row_chord+[.5,0,0]];

/*outer index and outer pinkie, spherical part of the keyboard it appears
in row pattern*/
tight_spherical_row = [row_chord+[5.2,0,0],
		       row_chord+[4.75,0,0],
		       row_chord+[4.5,0,0],//mounting screw
		       row_chord+[8.6,0,0]];//dkn
/*outer pinkey column, in column pattern*/
tight_spherical_col = [[row_chord+[-1.8,0,0]],
		       [row_chord+[.9,0,0]],
		       [row_chord+[0,0,0]],
		       [row_chord+[-.5,0,0]]];
spherical_z = [4,30,0,0];//rotation of outer pinky and outer index

pinkie_keys = true;//[[false],[true],[false],[false]];
pinkie_pos = [outerdia()+spacer()+20+2,-23,4];
pinkie_tent = [0,0,-2];
pinkie_tilt = [3,0,0];
pinkie_placement_params =
  layout_placement_params(homerow=homerow, homecol=1,
			  row_spacing=create_circular_placement([tight_spherical_row,
 								 [row_chord]]),
			  col_spacing=create_circular_placement(tight_spherical_col, z_correct=spherical_z),
			  profile_rows=[/*[4],*/profile_rows,profile_rows],
			  offsets=[0,0,0], tent=tent+pinkie_tent, tilt=pinkie_tilt+tilt,
			  position=pinkie_pos);

pinkie_mountings = [screw_mounting_params(row=0, col=0, height=10,
					  displacement=[2,-5.8,-15.3],
					  offsets=[0,0,-2],
					  layout_params=pinkie_placement_params),
		    screw_mounting_params(row=1, col=0, height=10, layout_params=pinkie_placement_params,
					  displacement=[28,14,-15]),
		    screw_mounting_params(row=2, col=0, height=6,
					  displacement=[5,3,-14],
					  layout_params=pinkie_placement_params)
		    ];
function tail(v) = assert(is_list(v)) len(v) == 2 ? [v[1]] : [ for (i = [1:len(v)-1]) v[i]];

module apply_screw_mountings(params, idx=0) {
  assert(is_list(params));

  screw_mounting(mounting_params=params[0], idx=idx)
    if (len(params) == 1) {
      children();
    } else {
      apply_screw_mountings(tail(params)) children();
    }
}

apply_screw_mountings(params=pinkie_mountings)
    union() {
    layout_columns(rows=[rows-1,rows], cols=cols, params=pinkie_placement_params,
		   keys=false);
    hull() {
      layout_placement(2, 0, params=pinkie_placement_params) key_mount_side_bounding_box(y=-1, rightside=true,
										       footer=true);
      layout_placement(3, 1, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, leftside=true,
											 footer=true);
    }
    hull() {
      layout_placement(2, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=-1,y=-1, rightside=true,
											 footer=true);
      layout_placement(3, 1, params=pinkie_placement_params) key_mount_side_bounding_box(x=1, leftside=true,
										       footer=true);
    }
    hull() {
      layout_placement(2, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(y=-1, x=-1,
											 rightside=true,
											 footer=true);
      /*layout_placement(3, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(y=1, x=-1,
	rightside=true,
	footer=true);*/
      layout_placement(2, 1, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, leftside=true
											 );
      layout_placement(3, 1, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=1, leftside=true,
											 footer=true);
    }

    layout_placement(row=2, col=0, homerow=2, homecol=2, profile_rows=4, offsets=[0,-.1,0],params=pinkie_placement_params) key_mount(header=true, footer=true, rightside=true);

    hull() {
      layout_placement(3, 1, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, leftside=true,
											 footer=true);
      layout_placement(2, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1,y=-1, rightside=true,
											 footer=true);
      layout_placement(row=2, col=0, homerow=2, homecol=2, profile_rows=4, offsets=[0,-.1,0], params=pinkie_placement_params)
	key_mount_corner_bounding_box(x=-1,y=-1, rightside=true, header=true, footer=true);
    }
    hull() {
      layout_placement(3, 1, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, leftside=true,
											 footer=true);
      layout_placement(row=2, col=0, homerow=2, homecol=2, profile_rows=4, offsets=[0,-.1,0], params=pinkie_placement_params)
	key_mount_side_bounding_box(y=-1, rightside=true, header=true, footer=true);
    }
    hull() {
      layout_placement(row=2, col=0, homerow=2, homecol=2, profile_rows=4, offsets=[0,-.1,0], params=pinkie_placement_params)
	key_mount_side_bounding_box(x=-1, rightside=true, header=true, footer=true);
      layout_placement(2, 0, params=pinkie_placement_params) key_mount_side_bounding_box(x=1, rightside=true,
										       footer=true);
    }

    hull() {
      layout_placement(row=2, col=0, homerow=2, homecol=2, profile_rows=4, offsets=[0,-.1,0], params=pinkie_placement_params)
	key_mount_corner_bounding_box(x=-1, y=1, header=true);
      layout_placement(2, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=1, rightside=true);
      layout_placement(1, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, rightside=true);
    }
    hull() {
      layout_placement(row=2, col=0, homerow=2, homecol=2, profile_rows=4, offsets=[0,-.1,0], params=pinkie_placement_params)
	key_mount_corner_bounding_box(x=1,y=1, rightside=true, header=true, footer=true);
      layout_placement(0, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1,rightside=true,
											 header=true);
      layout_placement(1, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, rightside=true);
    }
    hull() {
      layout_placement(row=2, col=0, homerow=2, homecol=2, profile_rows=4, offsets=[0,-.1,0], params=pinkie_placement_params)
	key_mount_side_bounding_box(y=1, rightside=true, header=true, footer=true);
      layout_placement(1, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, rightside=true);
    }
    hull() {
      layout_placement(1, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, rightside=true);
      layout_placement(1, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=1, rightside=true);
      layout_placement(0, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, rightside=true,header=true);
    }
    hull() {
      *layout_placement(1, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=-1, rightside=true);
      *layout_placement(0, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=1, y=1, rightside=true,header=true);
      layout_placement(0, 0, params=pinkie_placement_params) key_mount_side_bounding_box(x=1, rightside=true,header=true);
      layout_placement(row=2, col=0, homerow=2, homecol=2, profile_rows=4, offsets=[0,-.1,0], params=pinkie_placement_params)
	key_mount_corner_bounding_box(x=1,y=1, rightside=true, header=true, footer=true);
    }
    hull() {
      layout_placement(0, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(x=-1, y=1, rightside=true,header=true);
      layout_placement(0, 1, params=pinkie_placement_params) key_mount_side_bounding_box(y=1, leftside=true,header=true);
    }

  }
  if (false) layout_placement(row=2, col=0, homerow=2, homecol=2, profile_rows=4, offsets=[0,-.1,0], params=pinkie_placement_params) keycap($effective_row);
  layout_columns(rows=[rows-1,rows], cols=cols, params=pinkie_placement_params,
		 keys=false?pinkie_keys:false, wells=false);
