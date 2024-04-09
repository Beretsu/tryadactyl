use <../settings.scad>;
use <../key/cap.scad>;
use <../column/util.scad>;
use <../column/layout.scad>;
use <../assembly/util.scad>;
use <../key/mount.scad>;

/*rows=4;
cols=3;

homerow=2;
homecol= 1;*/
rows=4;
cols=4;

homerow=2;
profile_rows=effective_rows(rows,homerow);
tilt=[-3,0,0];
tent=[0,32,0];
row_chord = [14.5,25,0];
col_chord = [14.5,215,0];
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
tight_spherical_col = [[col_chord],
		       [col_chord],
		       [col_chord],
		       [col_chord]];
spherical_z = [4,30,0,0];//rotation of outer pinky and outer index

index_keys= true;//shows index keys
index_pos = [-(outerdia()+4),-4,6];//translate index cluster x,y,z
index_tent = [0,0,5];//whole index cluster
index_tilt = [0,0,0];//"
index_rows= [rows, rows, rows, rows];
index_cols=cols;
index_placement_params =
  layout_placement_params(homerow=[homerow,homerow,homerow,homerow], homecol=1,
			  row_spacing=create_circular_placement([tight_cylindrical_row, tight_cylindrical_row, tight_cylindrical_row, tight_cylindrical_row]), col_spacing=create_circular_placement(tight_spherical_col),
			  profile_rows=[profile_rows,profile_rows,profile_rows, profile_rows],
			  tent=index_tent+tent, tilt=index_tilt, position=index_pos);
layout_columns(rows=index_rows, cols=index_cols, params=index_placement_params, keys=index_keys);
//layout_columns(rows=rows, cols=cols,homerow=homerow,homecol=homecol, keys=false, perimeter=true, reverse_triangles=false, leftwall=true, rightwall=true, topwall=true, bottomwall=true);
//layout_plate_only();