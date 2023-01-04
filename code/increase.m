function path_out = increase(path_in,inc)
len = length(path_in);
[T,R]=cart2pol(path_in(2,:),path_in(3,:));
for j = 1: len
    R(j) = R(j)+inc*j/len; %increase y and z values slightly 
end
[Y,Z]=pol2cart(T,R);
path_in(2,:)=Y;
path_in(3,:)=Z;
path_out = path_in;
end