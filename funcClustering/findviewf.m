function [viewid, featid] = findviewf(add2, k)

ok = 1;
many = 0;
sum2 = 0;
while ok
    many = many + 1;
    sum2 = sum2 + add2(many);
    if k<=sum2
       ok = 0; 
    end
end
viewid = many;
featid = k-(sum2-add2(many));

end