use <../assembly/util.scad>;

mounting= screw_mounting_params(row=0, col=0, headroom= [[1,2],[1,2]], footroom=[[4,3],[4,3]]);

screw_mounting(mounting_params=mounting);

mounting2= screw_mounting_params(row=0, col=1, headroom= [[0,0],[2,7]], footroom=[[2,2],[2,2]]);

screw_mounting(mounting_params=mounting2);