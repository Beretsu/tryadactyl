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
index_pos = [-(outerdia()+4),-4,6];

thumb_keys= true;
thumb_pos = index_pos + [-1.5*(outerdia()+spacer())+30,-3.5*(outerdia()+spacer())-1,-30];
thumb_tilt = [10,-100,25];
thumb_tent = tent+[0,0,-5];
thumb_row_chord_sides = [30, 25, 0];
thumb_row_chord_center = [14.5, 0, 60];
thumb_placement_params =
  layout_placement_params(homerow=1//[0,1,0]
			  , homecol=1,
			  row_spacing=create_circular_placement([[thumb_row_chord_sides],
								 [thumb_row_chord_center],
								 [thumb_row_chord_sides]]),
			  col_spacing = create_circular_placement([[[17,16,0]],[[20,20,0]]],z_correct=60),
			  profile_rows=[[2,3],["SKRH",3],[2,1]],
			  tent=thumb_tent, tilt=thumb_tilt,
			  position=thumb_pos);

thumb_mountings = [screw_mounting_params(row=0, col=1, height=6, displacement=[4,6,-13],
					 layout_params=thumb_placement_params),
		   screw_mounting_params(row=0, col=1, height=6, displacement=[2,-13,-16],
					 headroom= [[2,2],[2,10]], footroom=[[2,2],[2,1]],layout_params=thumb_placement_params),
		   screw_mounting_params(row=0, col=0, height=30, offsets=[0,0,0], displacement=[0,-4.8,-16.0],
					 headroom=[[2,3],[2,10]], footroom=[[6,2],[2,2]],
					 layout_params=thumb_placement_params)
		];

/*
  thumb_keys= [false,true,false];
thumb_pos = index_pos + [-1.75*(outerdia()+spacer()),-2.5*(outerdia()+spacer())+7,-15 -5];
thumb_row_chord_sides = [20.5,500,0];
thumb_row_chord_center = [14.5, 50,0];
thumb_placement_params =
  layout_placement_params(homerow=0, homecol=1,
			  row_spacing = create_flat_placement(19.1),
			  col_spacing = create_circular_placement([[[14,16,0]],[[18,32,0]]],z_correct=0),
			  profile_rows=[[3,2],[3,"SKRH"],[1,2]],
			  tent=tent+[-10,0,0], tilt=[20,-80,0],
			  position=thumb_pos);

thumb_mountings = [screw_mounting_params(row=0, col=1, height=10, displacement=[-0.5,-13,-15],
					 headroom= [[1,0],[2,7]], layout_params=thumb_placement_params),
		   screw_mounting_params(row=0, col=1, height=10, displacement=[1,6,-15],
					 layout_params=thumb_placement_params),
		   screw_mounting_params(row=0, col=0, height=30, offsets=[0,0,0], displacement=[4,0,-21],
					 headroom=[[2,3],[2,7]], footroom=[[7,2],[2,2]],
					 layout_params=thumb_placement_params)
		];
*/

/*thumb_pos = index_pos + [-2*(outerdia()+spacer()),-2.5*(outerdia()+spacer())+7+1,-15 -5];
thumb_row_chord_sides = [20.5,40,0];
thumb_row_chord_center = [14.5,32,0];
thumb_placement_params =
  layout_placement_params(homerow=0, homecol=1,
			  row_spacing=create_circular_placement([[thumb_row_chord_sides],
								 [thumb_row_chord_center],
								 [thumb_row_chord_sides]]),
			  col_spacing = create_circular_placement([[[12,14,0]],[[14,14,0]]],z_correct=21),
			  profile_rows=[[3,2],[3,"SKRH"],[3,2]],
			  tent=tent+[-10,0,0], tilt=[normalize_chord(thumb_row_chord_center)[2]+10,-60,0],
			  position=thumb_pos);

thumb_mountings = [screw_mounting_params(row=0, col=1, height=10, displacement=[-0.5,-3,-16],
					 layout_params=thumb_placement_params),
		   screw_mounting_params(row=0, col=1, height=10, displacement=[1,15,-15],
					 layout_params=thumb_placement_params),
		   screw_mounting_params(row=0, col=0, height=35, offsets=[0,0,0], displacement=[6.5,0,-20],
					 headroom=[[2,3],[2,7]],
					 layout_params=thumb_placement_params)
		];
*/
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

let(rows=2//[1,2,1]
      ,cols=3) {
    apply_screw_mountings(params=thumb_mountings) {
      layout_columns(rows=rows, cols=cols, params=thumb_placement_params,
		     keys=false, perimeter=true, reverse_triangles=false);
      *hull() {
	layout_placement(0,2, params=thumb_placement_params) key_mount_bounding_box(y=1, header=true, leftside=true);
     	layout_placement(0,0, params=thumb_placement_params) key_mount_bounding_box(y=1, header=true, rightside=true);
      }
      hull() {
	layout_placement(0,1, params=thumb_placement_params) key_mount_bounding_box(y=1, header=true);
	layout_placement(0,2, params=thumb_placement_params) key_mount_bounding_box(y=1,x=1, header=true, leftside=true);
      }
      hull() {
	layout_placement(0,1, params=thumb_placement_params) key_mount_bounding_box(y=1,x=1, header=true);
	layout_placement(0,2, params=thumb_placement_params) key_mount_bounding_box(y=1,x=1, header=true, leftside=true);
     	layout_placement(0,0, params=thumb_placement_params) key_mount_bounding_box(y=1,x=-1, header=true, rightside=true);
      }
    }
    layout_columns(rows=rows, cols=cols, params=thumb_placement_params,
		   keys=true?thumb_keys:false, wells=false);
}
