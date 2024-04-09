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

middle_keys = true;
//middle_offset = [[0,0,0], [0,4,1]];
middle_offset = [0,5,0];
ring_offset=[1,-5,-1];
middle_rotation = [0,0,0];
middle_placement_params =
  layout_placement_params(homerow=homerow, homecol=1,
			  row_spacing=create_circular_placement(tight_cylindrical_row),//applies to all columns
			  col_spacing=create_flat_placement(outerdia()+spacer()),
			  profile_rows=profile_rows,
			  offsets=[ring_offset, middle_offset], tent=tent, tilt=middle_rotation+tilt);
middle_mountings = [screw_mounting_params(row=0, col=0, height=30, headroom=[[1,3],[2,7]], footroom=[[2,0],[2,2]],
					  layout_params=middle_placement_params,
					  /*displacement=[1.3,.4,-15],*/displacement=[0,1.6,-15-3], offsets=[0,0, -4]),
		    screw_mounting_params(row=1, col=1, height=20, layout_params=middle_placement_params,
					  displacement=[15.5,-2,-15.5], headroom=[[2,2],[2,7]],
					  offsets=middle_offset+[0,0,-1]),
		    screw_mounting_params(row=3, col=0, height=35, headroom=[[2,2],[2,7]],
					  layout_params=middle_placement_params,
					  displacement=[-7.5,-1.5,-17], offsets=[0,0,0])];

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

apply_screw_mountings(params=middle_mountings) {
    layout_columns(rows=rows, cols=cols, params=middle_placement_params,
           rightsides=[true,false],
           //rightwall=true, topwall=false, bottomwall=false, narrowsides=false, perimeter=true,
           keys=false);
    hull() {
      layout_placement(3, 0, params=middle_placement_params) key_mount_corner_bounding_box(x=-1, y=-1,
                                             footer=true);
      layout_placement(3, 1, params=middle_placement_params) key_mount_side_bounding_box(y=-1, leftside=true,
                                               footer=true);
    }
}
layout_columns(rows=rows, cols=cols, params=middle_placement_params,
		 keys=true?middle_keys:false, wells=false);
