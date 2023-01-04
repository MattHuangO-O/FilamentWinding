function [layer,n] = layer_Generator(w, R, cycle, num_cycles)
offset = w / R * 180 / pi; %width angle
start = 360 / num_cycles; 

n = ceil(start / offset);
offset = start / n;
L = length(cycle);

layer = zeros(3,n*L);
layer(:,1:L) = cycle;

for i = 1:n-1
    Rotate = rotx(offset); %rotate angle by this amount see formula
    rot_layer = layer(:,(i-1)*L+1:(i)*L); %take the previous layer and store in rot_layer
    
    rot_layer = mtimes(Rotate, rot_layer); %rotate rot_layer
    
    layer(:, (i*L)+1:(i+1)*L) = rot_layer; %save the rotated rot_layer in the layer array
end

end