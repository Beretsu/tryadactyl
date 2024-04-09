use <../settings.scad>;
use <../key/cap.scad>;
use <../column/util.scad>;
use <../column/layout.scad>;
use <../assembly/util.scad>;
use <../key/mount.scad>;
use <../util.scad>;

rows=3;
cols=2;

homerow=1;
profile_rows=effective_rows(rows,homerow);
tilt=[0,0,0];
tent=[0,0,0];
row_chord = [14.5,25,0];
index_keys= true;
index_pos = [-(outerdia()+2.5),-4,4];
index_tent = [0,0,2];
index_tilt = [0,0,0];
index_rows= rows;
index_cols=cols;
index_placement_params =
  layout_placement_params(homerow=homerow, homecol=0,
			  row_spacing=create_circular_placement(row_chord),
			  col_spacing=create_flat_placement(outerdia()+spacer()),			 profile_rows=profile_rows,
			  tent=index_tent+tent, tilt=index_tilt, position=index_pos);

index_mountings = [screw_mounting_params(row=1, col=0, height=10, displacement=[0, -.8, -16.5],
					 headroom=[[2,2.5], [2,10]], footroom=[[2,0],[2,2]], layout_params=index_placement_params),
                     screw_mounting_params(row=-1, col=-1, height=18, displacement=[-3,-1,-19], headroom=[[1,3], [2,10]], layout_params=index_placement_params)];

middle_keys = true;
middle_offset = [0,5,0];
ring_offset=[0,-5,1];
middle_rotation = [0,0,0];
middle_placement_params =
  layout_placement_params(homerow=homerow, homecol=1,
			  row_spacing=create_circular_placement(row_chord),
			  col_spacing=create_flat_placement(outerdia()+spacer()),
			  profile_rows=profile_rows,
			  offsets=[ring_offset, middle_offset], tent=tent, tilt=middle_rotation+tilt);

middle_mountings = [screw_mounting_params(row=-1, col=0, height=16, headroom=[[1,3],[2,7]],
					  layout_params=middle_placement_params,
					  displacement=[5,-1.5,-16.5], offsets=[0,0,0]),
		    screw_mounting_params(row=1, col=1, height=6, layout_params=middle_placement_params,
					  displacement=[16.4,-.3,-15.5], headroom=[[.85,2],[2,7]], footroom=[[2,0],[2,2]],
					  offsets=middle_offset+[0,0,-1]),
		    screw_mounting_params(row=2, col=0, height=18, headroom=[[2,2],[2,7]],
					  layout_params=middle_placement_params,
					  displacement=[-8.5,-1.5,-15], offsets=[0,0,0])];

              
pinkie_keys = true;//[[false],[true],[false],[false]];
pinkie_cols = 1;
pinkie_pos = [(outerdia()+spacer())*2+1,-23,8];
pinkie_tent = [0,0,-1];
pinkie_tilt = [3,0,0];
pinkie_placement_params =
  layout_placement_params(homerow=homerow, homecol=0,
			  row_spacing=create_circular_placement(row_chord),
			  col_spacing=create_flat_placement(outerdia()+spacer()),
			  profile_rows=profile_rows,
              tent=tent+pinkie_tent, tilt=pinkie_tilt+tilt,
			  position=pinkie_pos);

pinkie_mountings = [screw_mounting_params(row=-1, col=-1, height=26,
					  displacement=[-5,0,-17],
					  offsets=[0,0,-3],headroom=[[1,3],[2,7]],
					  layout_params=pinkie_placement_params),
		    screw_mounting_params(row=2, col=0, height=18,
					  displacement=[-5,-7.5,-13.5],offsets=[0,0,0],headroom=[[1,3],[2,7]],
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

module mounted_index(keys=true) {
    apply_screw_mountings(params=index_mountings) {
        union() {
            layout_columns(rows=index_rows, cols=index_cols, params=index_placement_params,
                   keys=keys);
            hull() {
                layout_placement(0,1,params=middle_placement_params)
                key_mount_corner_bounding_box(x=-1,y=1,leftside=true,header=true);
                
                layout_placement(0,0,params=index_placement_params)
                key_mount_side_bounding_box(y=1,rightside=true,header=true);
            }
        }
    }
}

module mounted_middle(keys=true) {
    apply_screw_mountings(params=middle_mountings) {
        layout_columns(rows=rows, cols=cols, params=middle_placement_params,
               rightsides=[true,false],
               keys=keys);
        hull() {
          layout_placement(2, 0, params=middle_placement_params) key_mount_corner_bounding_box(x=-1, y=-1,
                                                 footer=true);
          layout_placement(2, 1, params=middle_placement_params) key_mount_side_bounding_box(y=-1, leftside=true,
                                                   footer=true);
        }
        hull() {
            layout_placement(0,0, params=middle_placement_params)
                key_mount_side_bounding_box(y=1, header=true, rightside=true);
            
            layout_placement(0,1, params=middle_placement_params)
                key_mount_corner_bounding_box(x=1, y=1, header=true, rightside=true);
        }
        hull() {
          layout_placement(2, 0, params=middle_placement_params) key_mount_bounding_box(x=-1, y=-1,
                                                 footer=true);
          layout_placement(2, 1, params=middle_placement_params) key_mount_bounding_box(x=-1, y=-1, leftside=true,
                                                   footer=true);
                layout_placement(2, 0, params=index_placement_params) key_mount_bounding_box(x=1, y=-1,
                                                footer=true);
        }
    }
}

module mounted_pinkie(keys=true) {
    apply_screw_mountings(params=pinkie_mountings) {
        layout_columns(rows=rows, cols=pinkie_cols, params=pinkie_placement_params,
       keys=keys);
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

module strut_mounted_finger_plates(keys=true) {
    mounted_index(false);
    mounted_middle(false);
    mounted_pinkie(false);
    join_columns(rows,index_placement_params,middle_placement_params);
    join_columns(rows,middle_placement_params,pinkie_placement_params,right_side_col=0);
}

module base_plate(z=-48, debug=true) {
    //flatten all the mountings into a single array
    mountings = [each index_mountings, each middle_mountings, each pinkie_mountings];
    
    plate(mountings, z=z,debug=debug);
}

module plate(mountings, z=-31, thickness=4, debug=true) {
    if(debug) {
        for(mount=mountings) {
            screw_mounting(mounting_params=mount, idx=1, clearance=true);
            #mount_bounding_box(z=z,thickness=thickness, mounting_params=mount);
        }
    }
}
strut_mounted_finger_plates();
base_plate(-30);
