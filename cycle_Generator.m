function [g_out] = cycle_Generator(num_cycles, deg_revolutions, g_in, n_pts)
L = 6 * n_pts;
g_out = zeros(3, num_cycles * L);

g_out(:, 1:L) = g_in;

for i = 1: num_cycles-1
    Rotate = rotx(2*deg_revolutions); %rotate angle by this amount see formula (2*degree rev so that u start where u end)
    g_rot = g_out(:,(i-1)*L+1:(i)*L);
    
    g_rot = mtimes(Rotate, g_rot);
    
    g_out(:, i*L+1:(i+1)*L) = g_rot;
end

end