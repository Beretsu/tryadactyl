use <../settings.scad>;
use <../key/cap.scad>;
use <../column/util.scad>;
use <../column/layout.scad>;
use <../assembly/util.scad>;
use <../key/mount.scad>;

rows=3;
cols=2;
homerow=1;
row_chord = [14.5,25,0];

board_placement_params = layout_placement_params(homerow=homerow,homecol=0,row_spacing=create_circular_placement(row_chord),
			  col_spacing=create_flat_placement(outerdia()+spacer()),
			  profile_rows=effective_rows(),
 tent=[0,5,0], tilt=[0,0,0], position=[0,0,0], offsets=[0,0,0], displacement=[0,0,0]);
 
board_mountings = screw_mounting_params(row=0, col=0, height=6,displacement=[0,0,-15],offsets=[0,0,0], layout_params=board_placement_params);

screw_mounting(mounting_params=board_mountings)
    layout_columns(rows=rows,cols=cols,params=board_placement_params);