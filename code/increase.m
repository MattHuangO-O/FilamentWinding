function path_out = increase(path_in)
len = length(path_in);
inc = .125 / len;
for j = 1: len
    path_in(2,j) = path_in(2,j) + inc*j; %increase y and z values slightly
    path_in(3,j) = path_in(3,j) + inc*j;
end
path_out = path_in;
end