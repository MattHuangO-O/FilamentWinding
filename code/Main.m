%% user inputs
alpha = 15 * pi / 180; %wind angle (radians)
S_F = 710000;%fiber strength
Pr = 1000;%pressure
N = 2; %safety factor
D = 8; %diameter
w = .25; %filament width
th = .004;%filament thickness
r_0 = 1;%starting radius
n_pts = 30; %number of points
R = D/2; %Radius 
polar_alpha = asin(r_0 / R); %see figure 1

P = 2*D / tan(alpha); % (6) pitch
cyl_Length = 12;
revolutions = cyl_Length / P; % (7)
rad_revolutions = revolutions * 2 * pi; % (8)
deg_revolutions = revolutions * 360; %degrees that the cylinder rotates in helical portion

n = (2*deg_revolutions) / 360; %calculates how many full revolutions gone in the cylindrical portion
start = 2*deg_revolutions - 360*(floor(n));

[left, right] = polarWind(R, polar_alpha, cyl_Length, n_pts);
[forward, backwards, starts] = helicalWind(R, cyl_Length, alpha, n_pts);
left_start = [left(1,1:n_pts); left(2,1:n_pts); left(3,1:n_pts)];


num_cycles = find_cycles(deg_revolutions, 2); 

%rotate right hemispherical endcap by one helical revolution (forward)
phi_diff = deg_revolutions;
Rotate = rotx(phi_diff);
right_rot = mtimes(Rotate, right);

%rotate left hemispherical endcap by two helical revolutions (forward and
%backwards)
Rotate2 = rotx(2*deg_revolutions);
left_rot = mtimes(Rotate2, left);
left_end = [left_rot(1,n_pts+1:end); left_rot(2,n_pts+1:end); left_rot(3,n_pts+1:end)];

circuit = [left_start, forward, right_rot, backwards, left_end];
phi = calculate_Mandrel_angle(circuit(2,:), circuit(3,:));


cycle = cycle_Generator(num_cycles, deg_revolutions, circuit, n_pts); %g-code for one cycle
full_layer = layer_Generator(w, R, cycle, num_cycles); %g-code for full layer


figure 
plot3(circuit(1,:), circuit(2,:), circuit(3,:));
axis('equal')

figure
plot3(cycle(1,:), cycle(2,:), cycle(3,:));
axis('equal')
%view(90,0)  % YZ

%animate(cycle)
figure
plot3(full_layer(1,:), full_layer(2,:), full_layer(3,:), 'LineWidth', 1);
axis('equal')
%animate(full_layer)
%view(90,0)  % YZ



%plot3(G(1,:), G(2,:), G(3,:), 'LineWidth',3);
%{
start_i = starts;
for i = 1:n
    start_i = i * start_i;
    Rotate = rotx(start_i);
    G_rot = mtimes(Rotate,G);
    x = G_rot(1,:);
    y = G_rot(2,:);
    z = G_rot(3,:);
    hold all
    plot3(x,y,z,'LineWidth',1);
    axis('equal')
    xlabel('x')
    ylabel('y')
    zlabel('z')
end
%}
