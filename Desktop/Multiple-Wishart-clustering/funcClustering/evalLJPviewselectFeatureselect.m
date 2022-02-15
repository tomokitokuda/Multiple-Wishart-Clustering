function LJP = evalLJPviewselectFeatureselect(c, view2, X, Z, V, F, T1, keepgammlan)

f = view2;
MaxGall = max(Z{f});
N1 = NaN(MaxGall, 1);
selectf = find(F==f);
for g = 1:MaxGall
    z_mask = (Z{f} == g);
    v_mask = (V{f} == c);
    if length(v_mask)>0
        X1_zv = X(selectf(v_mask),selectf(v_mask), z_mask);
        N1(g) = getsumgeoWish2(X1_zv, T1, keepgammlan);
    else 
        N1(g) = 0;
    end
end

LJP =  sum(N1);
  
end
