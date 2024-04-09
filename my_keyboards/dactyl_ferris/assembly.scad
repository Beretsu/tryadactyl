use <../../settings.scad>;
use <../../key/cap.scad>;
use <../../column/util.scad>;
use <../../column/layout.scad>;
//use <../../assembly/trackpoint.scad>;
use <../../assembly/util.scad>;
use <../../key/mount.scad>;
use <../../util.scad>;

rows=3;
cols=2;

homerow=1;
profile_rows=effective_rows(rows,homerow);
tilt=[-3,0,0];
tent=[0,32,0];
row_chord = [14.5,25,0];

index_keys= true;
index_pos = [-(outerdia()+2.5),-4,6];
index_tent = [0,0,5];
index_tilt = [0,0,0];
inner_index_offset=[0,0,0];
outer_index_offset=[0,-3,0];
index_rows= rows;
index_cols=cols;
index_placement_params =
  layout_placement_params(homerow=homerow, homecol=0,
			  row_spacing=create_circular_placement(row_chord),
			  col_spacing=create_flat_placement(outerdia()+spacer()),
			  profile_rows=profile_rows, offsets=[inner_index_offset,outer_index_offset],
			  tent=index_tent+tent, tilt=index_tilt, position=index_pos);

index_mountings = [/*screw_mounting_params(row=-1, col=1, height=63, layout_params=index_placement_params,
					 displacement=[9,0,-15], offsets=[0,0,0],
					 headroom=[[2,2], [2,7]], footroom=[[2, 2], [2, 2]]),
		   screw_mounting_params(row=2, col=0, height=50, displacement=[8,0,-18],offsets=[0,0,0],
					 headroom=[[2,2], [2,7]],footroom=[[2,2],[2,2]], layout_params=index_placement_params),*/
                     screw_mounting_params(row=-1,col=0,height=46, layout_params=index_placement_params, displacement=[8,0,-16], offsets=[0,1,0], headroom=[[2,2], [2,7]], footroom=[[2,2], [2,2]]),
                     /*screw_mounting_params(row=2, col=1,  height=60, layout_params=index_placement_params, displacement=[7,1,-20], offsets=[0,0,0], headroom=[[2,2], [2,7]], footroom=[[2,2], [2,2]])*/
                     /*screw_mounting_params(row=1,col=1,height=50,layout_params=index_placement_params, displacement=[-5,-10,-14.5], offsets=[0,0,0], headroom=[[2,2], [2,7]], footroom=[[2,2],[2,2]]),*/
                     screw_mounting_params(row=2,col=1,height=54,layout_params=index_placement_params, displacement=[-5,-4,-16.3], offsets=[0,0,0], headroom=[[2,2], [2,7]], footroom=[[2,2],[2,2]])
		   ];
           
middle_keys = true;
middle_offset = [0,5,0];
ring_offset=[0,-5,-1];
middle_rotation = [0,0,0];
middle_placement_params =
  layout_placement_params(homerow=homerow, homecol=1,
			  row_spacing=create_circular_placement(row_chord),
			  col_spacing=create_flat_placement(outerdia()+spacer()),
			  profile_rows=profile_rows,
			  offsets=[ring_offset, middle_offset], tent=tent, tilt=middle_rotation+tilt);
middle_mountings = [screw_mounting_params(row=-1, col=0, height=18, headroom=[[2,2],[2,7]], footroom=[[2,2],[2,2]],
					  layout_params=middle_placement_params,
					  displacement=[5.5,-1,-15],offsets=[0,0,-.3]),
		    screw_mounting_params(row=2, col=0, height=27, headroom=[[2,2],[2,7]],
					  layout_params=middle_placement_params,
					  displacement=[-9,-1.5,-17], offsets=[0,0,0])
		    ];

pinkie_cols= 1;
pinkie_keys = true;//[[false],[true],[false],[false]];
pinkie_pos = [(outerdia()+spacer())*2+1,-23,4];
pinkie_tent = [0,0,-2];
pinkie_tilt = [3,0,0];
pinkie_placement_params =
  layout_placement_params(homerow=homerow, homecol=0,
			  row_spacing=create_circular_placement(row_chord),
			  col_spacing=create_flat_placement(outerdia()+spacer()),
			  profile_rows=profile_rows,
			  offsets=[0,0,0], tent=tent+pinkie_tent, tilt=pinkie_tilt+tilt,
			  position=pinkie_pos);

pinkie_mountings = [screw_mounting_params(row=-1, col=0, height=12, layout_params=pinkie_placement_params,headroom=[[2,2],[2,7]], footroom=[[2,2],[2,2]],
					  displacement=[4,0,-19],offsets=[0,0,0]),
		    screw_mounting_params(row=2, col=0, height=18,headroom=[[2,2],[2,7]], footroom=[[2,2],[2,2]],
					  displacement=[-9,-6,-11], offsets=[0,0,0],
					  layout_params=pinkie_placement_params)
		    ];
            
thumb_keys= true;
thumb_pos = index_pos + [0,-2*(outerdia()+spacer()),0];
thumb_tilt = [10,-100,25];
thumb_tent = tent+[0,0,-5];
thumb_placement_params =
  layout_placement_params (homerow=0, homecol=0, row_spacing=create_flat_placement(outerdia()+spacer()+1.2), col_spacing=create_circular_placement([11,9,0]), profile_rows=profile_rows, tent=thumb_tent, tilt=thumb_tilt, position=thumb_pos);

thumb_mountings = [screw_mounting_params(row=0, col=0, height= 30, displacement=[0,8,-15], headroom= [[2,2],[2,7]], footroom=[[2,2],[2,2]],layout_params=thumb_placement_params)
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

/*index_bugfix_placement_params =
  layout_placement_params(homerow=homerow, homecol=0,
			  row_spacing=create_circular_placement(row_chord),
			  col_spacing=create_flat_placement(outerdia()+spacer()),
			  profile_rows=profile_rows, offsets=outer_index_offset,
			  tent=index_tent+tent, tilt=index_tilt, position=index_pos);*/

module mounted_index(keys=true) {
  apply_screw_mountings(params=index_mountings) {
    /*install_trackpoint(row=0,col=1,use_shield=true,w1=5,shield=[4,11,12.3], shield_angle=[-90,-90], displacement=tp_disp ,params=index_bugfix_placement_params)*/
    union() {
    layout_columns(rows=index_rows, cols=index_cols, params=index_placement_params,
		   keys=false);
    *hull() {
    layout_placement(2,1,params=index_placement_params)
        key_mount_corner_bounding_box(x=1,y=-1, footer=true);
        
    layout_placement(2,0,params=index_placement_params)
      key_mount_sidescrew_bounding_box(y=-1,footer=true, rightside=true);
    }
    *hull() {
    layout_placement(0,0,params=index_placement_params)
      key_mount_corner_bounding_box(x=-1,y=1,header=true);
        
    layout_placement(0,1,params=index_placement_params)
      key_mount_sidescrew_bounding_box(y=1,header=true,leftside=true);
    }
    layout_placement(0,0,params=index_placement_params)
      key_mount_sidescrew_bounding_box(y=1,header=true,rightside=true);
    
    *layout_placement(2,1,params=index_placement_params)
      key_mount_sidescrew_bounding_box(y=-1,footer=true,leftside=true);
    
    *layout_placement(1,1,params=index_placement_params)
      key_mount_sidescrew_bounding_box(x=-1, leftside=true);
    
    layout_placement(2,1,params=index_placement_params)
      key_mount_sidescrew_bounding_box(x=-1, leftside=true, footer=true);
    }
  }
  layout_columns(rows=index_rows, cols=index_cols, params=index_placement_params,
		   keys=keys?index_keys:false, wells=false);
}

module mounted_middle(keys=true) {
  apply_screw_mountings(params=middle_mountings) {
    layout_columns(rows=rows, cols=cols, params=middle_placement_params,
		   rightsides=[true,false],
		   keys=false);
    hull() {
      layout_placement(2, 0, params=middle_placement_params) key_mount_corner_bounding_box(x=-1, y=-1,
											 footer=true);
      layout_placement(2, 1, params=middle_placement_params) key_mount_side_bounding_box(y=-1, leftside=true,
										       footer=true);
    }
    hull() {
      layout_placement(2, 0, params=middle_placement_params) key_mount_bounding_box(x=-1, y=-1,
											 footer=true);
      layout_placement(2, 1, params=middle_placement_params) key_mount_bounding_box(x=-1, y=-1, leftside=true,
										       footer=true);
            layout_placement(2, 0, params=index_placement_params) key_mount_bounding_box(x=1, y=-1,
											footer=true,
										       rightside=true);
    }
    hull() {
        layout_placement(0,0, params=middle_placement_params)
            key_mount_side_bounding_box(y=1, header=true, rightside=true);
        
        layout_placement(0,1, params=middle_placement_params)
            key_mount_corner_bounding_box(x=1, y=1, header=true, rightside=true);
    }
  }
    layout_columns(rows=rows, cols=cols, params=middle_placement_params,
		   keys=keys?middle_keys:false, wells=false);
}

module mounted_pinkie(keys=true) {
  apply_screw_mountings(params=pinkie_mountings) {
    layout_columns(rows=rows, cols=pinkie_cols, params=pinkie_placement_params,
		   keys=false);
    hull() {
        layout_placement(2,0,params=pinkie_placement_params)
        key_mount_side_bounding_box(x=-1,footer=true, leftside=true);
        
        layout_placement(2,0,params=middle_placement_params)
        key_mount_side_bounding_box(y=-1,rightside=true,footer=true);
    }
    hull() {
        layout_placement(0,0,params=pinkie_placement_params)
        key_mount_side_bounding_box(y=1,leftside=true,rightside=true,header=true);
        
        layout_placement(0,0,params=middle_placement_params)
        key_mount_corner_bounding_box(x=1,y=1,rightside=true,header=true);
    }
  }
  layout_columns(rows=rows, cols=pinkie_cols, params=pinkie_placement_params, keys=keys?pinkie_keys:false, wells=false);
}

module mounted_thumb(keys=true) {
  let(rows=1 ,cols=2) {
    apply_screw_mountings(params=thumb_mountings)
      layout_columns(rows=rows, cols=cols, params=thumb_placement_params,
		     keys=false);
    layout_columns(rows=rows, cols=cols, params=thumb_placement_params, keys=keys?thumb_keys:false, wells=false);
  }
}

module join_columns(rows, params1, params2, left=false, right=false,right_side_col=1) {
  for (i=[0:rows-1]) {
    hull() {
      layout_placement(i, 0, params=params1) key_mount_side_bounding_box(x=1, rightside=!right,
								       header=(i==0), footer=(i==(rows-1)));
      layout_placement(i, right_side_col, params=params2) key_mount_side_bounding_box(x=-1, leftside=!left,
								       header=(i==0), footer=(i==(rows-1)));
    }
    if (i < rows -1) {
      hull() {
	layout_placement(i, 0, params=params1) key_mount_corner_bounding_box(x=1, y=-1, rightside=!right,
									   header=(i==0));
	layout_placement(i+1, 0, params=params1) key_mount_corner_bounding_box(x=1, y=1, rightside=!right,
									     footer=((i+1)==(rows-1)));
	layout_placement(i, right_side_col, params=params2) key_mount_corner_bounding_box(x=-1, y=-1, leftside=!left,
									   header=(i==0));
	layout_placement(i+1, right_side_col, params=params2) key_mount_corner_bounding_box(x=-1, y=1, leftside=!left,
									     footer=((i+1)==(rows-1)));
      }
    }
  }
}

module strut_mounted_finger_plates(keys=true, thumb=true) {
    if(thumb)
        mounted_thumb(keys);
    mounted_index(keys);
    mounted_middle(keys);
    mounted_pinkie(keys);
    join_columns(rows,index_placement_params,middle_placement_params);
    join_columns(rows,middle_placement_params,pinkie_placement_params,right_side_col=0);
}

//mounted_index(index_keys);
//mounted_middle(middle_keys);
//mounted_pinkie(pinkie_keys);

module base_plate(z=-40, debug=true) {
    //flatten all the mountings into a single array
    mountings = [each index_mountings, each middle_mountings, each pinkie_mountings, each thumb_mountings];
    
    difference() {
        mount_foot([-25,-36,z])//
        mount_foot([18,-15,z])//
        mount_foot([3,-41,z])//
        mount_foot([-49,-10,z])//
        mount_foot([-74,-10,z])//
        mount_foot([-74,19,z])//
        mount_foot([-49,19,z])//
        mount_foot([-18,19,z])
        mount_foot([19,19,z])
        mount_trrs([-5,24.3,z],[0,0,0])
        mount_promicro([-32, 14, z])
        bar_magnetize_below([-5,-5, z], [0,0,-45])
        mount_permaproto_flat([-80,-24.3, z])
        plate(mountings, z=z,debug=debug);
    }
}

module plate(mountings, z=-31, thickness=4, debug=true) {
    if(debug) {
        for(mount=mountings) {
            screw_mounting(mounting_params=mount, idx=1, clearance=true);
            #mount_bounding_box(z=z,thickness=thickness, mounting_params=mount);
        }
    } else {
        for (mount=mountings) {
          difference(){
            screw_mounting(mounting_params=mount, idx=1, clearance=debug);
            translate([0,0,-thickness]) mount_bounding_box(z=z, thickness=thickness, mounting_params=mount);
            translate([0,0,-2*thickness+.1]) mount_bounding_box(z=z, thickness=thickness, mounting_params=mount);
          }
        }
        difference() {
            hull() {
                for (mount=mountings) {
                    intersection() {
                        screw_mounting(mounting_params=mount, idx=1, clearance=false);
                        mount_bounding_box(z=z, thickness=thickness, mounting_params=mount);
                    }
                }
            }
            // diffing out the hull'd mountings keeps the plate hull above from filling in the cavities
          for (mount=mountings) {
            hull() {screw_mounting(mounting_params=mount, idx=1, clearance=true,blank=true);}
          }
        }
    }
}
//rigth side
strut_mounted_finger_plates(keys=false);
base_plate(debug=true);
//left side
*translate([-200,0,0])
    mirror([90, 0, 0]){
        strut_mounted_finger_plates(keys=true);
        base_plate(debug=true);
    }
