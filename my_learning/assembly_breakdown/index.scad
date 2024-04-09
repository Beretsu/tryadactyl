use <../../settings.scad>;
use <../../key/cap.scad>;
use <../../column/util.scad>;
use <../../column/layout.scad>;
use <../../assembly/trackpoint.scad>;
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
// Akko cherry PBT neesds a bit more space
tight_cylindrical_row =[row_chord+[.5/2,0,0],
			 row_chord+[.5,0,0],
			 row_chord,
			 row_chord+[.5,0,0]];

tight_spherical_row = [row_chord+[5.2,0,0],
		       row_chord+[4.75,0,0],
		       row_chord+[4.5,0,0],
		       row_chord+[8.6,0,0]];
tight_spherical_col = [[row_chord+[-1.8,0,0]],
		       [row_chord+[.9,0,0]],
		       [row_chord+[0,0,0]],
		       [row_chord+[-.5,0,0]]];
spherical_z = [4,30,0,0];

index_keys= true;
index_pos = [-(outerdia()+4),-4,6];
index_tent = [0,0,5];
index_tilt = [0,0,0];
index_rows= [rows, rows-1, 1];
index_cols=cols;

index_placement_params = layout_placement_params(homerow=[homerow,homerow,0], homecol=0,
			  row_spacing=create_circular_placement([tight_cylindrical_row, tight_spherical_row, [row_chord]]),
			  col_spacing=create_circular_placement(tight_spherical_col, z_correct=spherical_z),
			  profile_rows=[profile_rows,profile_rows,[4]],
			  tent=index_tent+tent, tilt=index_tilt, position=index_pos);
              
index_mountings = [screw_mounting_params(row=0, col=0, height=60, layout_params=index_placement_params,
					 displacement=[5,-1,-23], offsets=[0,0,-1],
					 headroom=[[10,0], [2,10]], footroom=[[12, 2], [2, 2]]),
		   screw_mounting_params(row=1, col=0, height=40, displacement=[-11, -1.8, -17],
					 headroom=[[1,2.6], [2,10]], layout_params=index_placement_params)];

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

  tp_disp = [6.5,11,0];
  tp_corner_disp = [11,2.8,0];

apply_screw_mountings(params=index_mountings) {
    install_trackpoint(2, 0, h1=13, h2=8.8, stem=0, up=-0, square_hole=false, access=true, tilt=tilt, use_shield=true,  shield=[4,12,15], shield_angle=[-69,-5], displacement=tp_disp, w1=14, params=index_placement_params)
    union() {
    layout_columns(rows=index_rows, cols=index_cols, params=index_placement_params,
		   keys=false);
    hull() {
      layout_placement(3, 0, params=index_placement_params) key_mount_side_bounding_box(x=-1, rightside=true,
											footer=true);
      layout_placement(2, 1, params=index_placement_params) key_mount_corner_bounding_box(y=-1, x=1, leftside=true,
											footer=true);
    }
    hull () {
      layout_placement(3, 0, params=index_placement_params, displacement=tp_corner_disp, corners=true)
	key_mount_corner_bounding_box(x=-1, y=1,leftside=true, footer=true);
      layout_placement(2, 1, params=index_placement_params) key_mount_side_bounding_box(y=-1, leftside=true,
										      footer=true);
    }
    hull () {
      layout_placement(3, 0, params=index_placement_params, displacement=tp_corner_disp, corners=true)
	key_mount_corner_bounding_box(x=-1, y=1,leftside=true, footer=true);
      layout_placement(3, 0, params=index_placement_params) key_mount_corner_bounding_box(x=-1, y=-1, rightside=true,
										      footer=true);
      layout_placement(2, 1, params=index_placement_params) key_mount_bounding_box(y=-1, x=1, leftside=true,
											footer=true);
    }

    *hull() {
      layout_placement(2, 1, params=index_placement_params) key_mount_corner_bounding_box(y=-1, x=1,
											footer=true);
      /*layout_placement(3, 0, params=pinkie_placement_params) key_mount_corner_bounding_box(y=1, x=-1,
	rightside=true,
	footer=true);*/
      layout_placement(2, 0, params=index_placement_params) key_mount_corner_bounding_box(x=-1, y=-1);
      layout_placement(3, 0, params=index_placement_params) key_mount_corner_bounding_box(x=-1, y=1,
											footer=true);
    }

    layout_placement(row=2, col=2, homerow=2, homecol=0, offsets=[0,-.1,0], params=index_placement_params) key_mount(header=true, footer=true, leftside=true);

    hull() {
      layout_placement(row=2, col=2, homerow=2, homecol=0, offsets=[0,-.1,0], params=index_placement_params)
	key_mount_bounding_box(x=1,header=true, footer=true, leftside=true);
      layout_placement(2, 1, params=index_placement_params) key_mount_bounding_box(x=-1, leftside=true,
											footer=true);
    }

    hull() {
      layout_placement(row=2, col=2, homerow=2, homecol=0, offsets=[0,-.1,0], params=index_placement_params)
	key_mount_bounding_box(x=1,y=-1, header=true, footer=true, leftside=true);
      layout_placement(2, 1, params=index_placement_params) key_mount_bounding_box(x=-1,y=-1, leftside=true,
										 footer=true);
      layout_placement(3, 0, params=index_placement_params, displacement=tp_corner_disp, corners=true)
	key_mount_corner_bounding_box(x=-1, y=1,leftside=true, footer=true);
    }
    hull() {
      layout_placement(row=2, col=2, homerow=2, homecol=0, offsets=[0,-.1,0], params=index_placement_params)
	key_mount_bounding_box(y=-1, header=true, footer=true, leftside=true);
           layout_placement(3, 0, params=index_placement_params, displacement=tp_corner_disp, corners=true)
	key_mount_corner_bounding_box(x=-1, y=1,leftside=true, footer=true);
    }

    hull() {
      layout_placement(row=2, col=2, homerow=2, homecol=0, offsets=[0,-.1,0], params=index_placement_params)
	key_mount_bounding_box(x=1,y=1, header=true, footer=true, leftside=true);
      layout_placement(2, 1, params=index_placement_params) key_mount_bounding_box(x=-1,y=1, leftside=true,
										 footer=true);
      layout_placement(1, 1, params=index_placement_params) key_mount_bounding_box(x=-1,y=-1, leftside=true,
										 footer=false);
    }

    hull() {
      layout_placement(row=2, col=2, homerow=2, homecol=0, offsets=[0,-.1,0], params=index_placement_params)
	key_mount_bounding_box(y=1, header=true, footer=true, leftside=true);
      layout_placement(1, 1, params=index_placement_params) key_mount_bounding_box(x=-1,y=-1, leftside=true);
    }

    hull() {
      layout_placement(row=2, col=2, homerow=2, homecol=0, offsets=[0,-.1,0], params=index_placement_params)
	key_mount_bounding_box(x=-1,y=1, header=true, footer=true, leftside=true);
      layout_placement(0, 1, params=index_placement_params) key_mount_bounding_box(x=-1, leftside=true,header=true);
    }

    hull() {
      layout_placement(row=2, col=2, homerow=2, homecol=0, offsets=[0,-.1,0], params=index_placement_params)
	key_mount_bounding_box(x=-1,y=1, header=true, footer=true, leftside=true);
      layout_placement(0, 1, params=index_placement_params) key_mount_bounding_box(x=-1, y=-1, leftside=true,header=true);
      layout_placement(1, 1, params=index_placement_params) key_mount_bounding_box(x=-1, y=-1, leftside=true);
    }

    hull() {
      layout_placement(0, 1, params=index_placement_params) key_mount_bounding_box(x=-1, y=-1, leftside=true,header=true);
      layout_placement(1, 1, params=index_placement_params) key_mount_bounding_box(x=-1, leftside=true);

    }

    hull() {
      layout_placement(0, 1, params=index_placement_params) key_mount_bounding_box(x=1, y=1, leftside=true,header=true);
      layout_placement(0, 0, params=index_placement_params) key_mount_bounding_box(y=1, header=true);

    }

  }
}
if (false) {
layout_placement(row=2, col=2, homerow=2, homecol=0, offsets=[0,-.1,0], params=index_placement_params) keycap($effective_row);
layout_columns(rows=index_rows, cols=cols, params=index_placement_params,
       keys=index_keys, wells=false);
}
/*screw_mounting(mounting_params=screw_mounting_params(row=0, col=0, height=60, layout_params=index_placement_params, displacement=[5,-1,-23], offsets=[0,0,-1], headroom=[[10,0], [2,10]], footroom=[[12, 2], [2, 2]])) {
    layout_columns(rows=index_rows, cols=index_cols, params=index_placement_params,
               keys=false);
}*/
