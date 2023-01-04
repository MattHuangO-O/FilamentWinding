function circuit = circuit_Generator(left, forward, right, backwards, deg_revolutions, n_pts)
left_start = [left(1,1:n_pts); left(2,1:n_pts); left(3,1:n_pts)];

%rotate right hemispherical endcap by one helical revolution (forward)
Rotate = rotx(deg_revolutions);
right_rot = Rotate*right;

%rotate left hemispherical endcap by two helical revolutions (forward and
%backwards)
Rotate2 = rotx(2*deg_revolutions);
left_rot = Rotate2*left;

left_end = [left_rot(1,n_pts+1:end); left_rot(2,n_pts+1:end); left_rot(3,n_pts+1:end)];
circuit = [left_start, forward, right_rot, backwards, left_end];
end