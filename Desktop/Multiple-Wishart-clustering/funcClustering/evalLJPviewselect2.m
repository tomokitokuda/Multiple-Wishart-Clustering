function [LJPtmp] = evalLJPviewselect2(X, Z, V, F, ALPHA0, BETA0, MaxCall, f, j, T1,  keepgammlan)
% Calcuate LJP for a specific view 
% f is the targeted view index
% j is the targeted feature index:
   
tempF = F;
LJPtmp = -inf(MaxCall(f),1);

for c = 1:MaxCall(f)
    temp = find(F==f); % feature ID for view = f
    tempV = V;
    [a, ~] = sort(temp, 'ascend');
    k = find(a==j); % Position of feature j in the view
    tempV{f} = insertelement(tempV{f}, k, c); % Insert value c at position k
    LJPselect2 = evalLJPviewselect(f, X, Z, tempV, tempF, ALPHA0, BETA0, T1,  keepgammlan);
    LJPtmp(c) = LJPselect2 ;  
end

end
