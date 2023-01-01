function [] = MainPlot(alpha,S_F,Pr,N,D,w,th,r_0,n_pts,cyl_Length,compl)
R = D/2; %Radius 
polar_alpha = asin(r_0 / R); %see figure 1

P = 2*D / tan(alpha); % (6) pitch
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
right_rot = Rotate*right;

%rotate left hemispherical endcap by two helical revolutions (forward and
%backwards)
Rotate2 = rotx(2*deg_revolutions);
left_rot = Rotate2*left;
left_end = [left_rot(1,n_pts+1:end); left_rot(2,n_pts+1:end); left_rot(3,n_pts+1:end)];
%%
circuit = [left_start, forward, right_rot, backwards, left_end];
phi = calculate_Mandrel_angle(circuit(2,:), circuit(3,:));

[Th_circuit,R_circuit]=cart2pol(circuit(2,:),circuit(3,:));

ThR_circuit=Th_circuit+w./R_circuit;
yR_circuit=R_circuit.*cos(ThR_circuit);
zR_circuit=R_circuit.*sin(ThR_circuit);
circuitR=[circuit(1,:);yR_circuit;zR_circuit];

ThL_circuit=Th_circuit-w./R_circuit;
yL_circuit=R_circuit.*cos(ThL_circuit);
zL_circuit=R_circuit.*sin(ThL_circuit);
circuitL=[circuit(1,:);yL_circuit;zL_circuit];

x_meshcir=[circuit(1,:);circuit(1,:)];
y_meshcir=[yL_circuit;yR_circuit];
z_meshcir=[zL_circuit;zR_circuit];
%%
cycle = cycle_Generator(num_cycles, deg_revolutions, circuit, n_pts); %g-code for one cycle

[Th_cycle,R_cycle]=cart2pol(cycle(2,:),cycle(3,:));

ThR_cycle=Th_cycle+w./R_cycle;
yR_cycle=R_cycle.*cos(ThR_cycle);
zR_cycle=R_cycle.*sin(ThR_cycle);
cycleR=[cycle(1,:);yR_cycle;zR_cycle];

ThL_cycle=Th_cycle-w./R_cycle;
yL_cycle=R_cycle.*cos(ThL_cycle);
zL_cycle=R_cycle.*sin(ThL_cycle);
cycleL=[cycle(1,:);yL_cycle;zL_cycle];

x_meshcyc=[cycle(1,:);cycle(1,:)];
y_meshcyc=[yL_cycle;yR_cycle];
z_meshcyc=[zL_cycle;zR_cycle];
%%
full_layer = layer_Generator(w, R, cycle, num_cycles); %g-code for full layer

[Th_full,R_full]=cart2pol(full_layer(2,:),full_layer(3,:));

ThR_full=Th_full+w./R_full;
yR_full=R_full.*cos(ThR_full);
zR_full=R_full.*sin(ThR_full);
fullR=[full_layer(1,:);yR_full;zR_full];

ThL_full=Th_full-w./R_full;
yL_full=R_full.*cos(ThL_full);
zL_full=R_full.*sin(ThL_full);
fullL=[full_layer(1,:);yL_full;zL_full];

x_meshfull=[full_layer(1,:);full_layer(1,:)];
y_meshfull=[yL_full;yR_full];
z_meshfull=[zL_full;zR_full];

%%
figure 
surf(x_meshcir,y_meshcir,z_meshcir)
axis('equal')

figure
plot3(circuit(1,:), circuit(2,:), circuit(3,:));
%hold on
%plot3(circuitR(1,:), circuitR(2,:), circuitR(3,:));
%plot3(circuitL(1,:), circuitL(2,:), circuitL(3,:));
axis('equal')

figure
surf(x_meshcyc,y_meshcyc,z_meshcyc)
axis('equal')

figure
plot3(cycle(1,:), cycle(2,:), cycle(3,:));
axis('equal')
%view(90,0)  % YZ

%animate(cycle)

figure
%surf(x_meshfull,y_meshfull,z_meshfull)
layern=length(full_layer)*compl;
surf(x_meshfull(:,1:layern),y_meshfull(:,1:layern),z_meshfull(:,1:layern))
axis('equal')

figure
plot3(full_layer(1,1:layern), full_layer(2,1:layern), full_layer(3,1:layern), 'LineWidth', 1);
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
