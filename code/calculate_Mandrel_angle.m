function [phi] = calculate_Mandrel_angle(y, z)
phi = zeros(1,length(y));
for i=1:length(y)
    if z(i) > 0 && y(i) >= 0
        phi(i) = atand(z(i)/y(i));
    elseif z(i) > 0 && y(i) < 0
        phi(i) = atand(z(i)/y(i)) + 180;
    elseif z(i) < 0 && y(i) <= 0
        phi(i) = atand(z(i)/y(i)) + 180;
    else
        phi(i) = atand(z(i)/y(i)) + 360;
    end
end

end