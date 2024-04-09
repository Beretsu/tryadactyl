use <../../settings.scad>;
use <../../key/cap.scad>;
use <../../column/util.scad>;
use <../../column/layout.scad>;
use <../../assembly/util.scad>;
use <../../key/mount.scad>;

rows=4;
cols=2;

homerow=2;
profile_rows=effective_rows(rows,homerow);
tilt=[-3,0,0];
tent=[0,32,0];
row_chord = [14.5,25,0];

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
index_placement_params =
  layout_placement_params(homerow=[homerow,homerow,0], homecol=0,
			  row_spacing=create_circular_placement([tight_cylindrical_row, tight_spherical_row, [row_chord]]),
			  col_spacing=create_circular_placement(tight_spherical_col, z_correct=spherical_z),
			  profile_rows=[profile_rows,profile_rows,[4]],
			  tent=index_tent+tent, tilt=index_tilt, position=index_pos);

index_mountings = [screw_mounting_params(row=0, col=0, height=60, layout_params=index_placement_params,
					 displacement=[5,-1,-23], offsets=[0,0,-1],
					 headroom=[[10,0], [2,10]], footroom=[[12, 2], [2, 2]]),
		   screw_mounting_params(row=1, col=0, height=40, displacement=[-11, -1.8, -17],
					 headroom=[[1,2.6], [2,10]], layout_params=index_placement_params)
		   ];


middle_keys = true;
//middle_offset = [[0,0,0], [0,4,1]];
middle_offset = [0,5,0];
ring_offset=[1,-5,-1];
middle_rotation = [0,0,0];
middle_placement_params =
  layout_placement_params(homerow=homerow, homecol=1,
			  row_spacing=create_circular_placement(tight_cylindrical_row),
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
					  displacement=[-7.5,-1.5,-17], offsets=[0,0,0])
		    ];


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
        
mountings = [each index_mountings, each middle_mountings, each pinkie_mountings];
module plate(mountings, z, thickness=4) {
    for(mount=mountings) {
        screw_mounting(mounting_params=mount, idx=1, clearance=true);
        #mount_bounding_box(z=z, thickness=thickness, mounting_params=mount);
    }
}
plate(mountings, z=-48);