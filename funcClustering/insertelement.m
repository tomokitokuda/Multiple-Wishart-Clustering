function y = insertelement(x, k, a)
% This inserts value a at kth position for an array x

len = length(x);
if len==0
    y = a;
else
    y = NaN(1, length(x)+1);
    many = 0;
    for i=1:(len+1)
        if i==k
            y(i) = a;
        else
            many = many + 1;
            y(i) = x(many);
        end
    end
end

end