function LJP = evalLJPviewselectObjectselectClassify(g, view2, X, Z, V, F,T1)

f = view2;
MaxGall = max(Z{f});
MaxCall = max(V{f});
N1 = NaN(MaxGall, MaxCall);

% Allocate memory to compute the sufficient statistics
selectf = find(F==f);
z_mask = (Z{f} == g);
for c = 1:MaxCall
    v_mask = (V{f} == c);
    if length(v_mask)>0
        X1_zv = X(selectf(v_mask),selectf(v_mask), z_mask);
        N1(g,c) = getsumgeoWish2subjectClassify(X1_zv, T1);
    else 
        N1(g,c) = 0;
    end
end

LJP =  sum(N1(g, :));
end

