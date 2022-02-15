function LJP = evalLJPviewselect(view2, X, Z, V, F, ALPHA0, BETA0, T1, keepgammlan)
% This is for evaluation of LJP (logarithm of posterior) for a view

[~, ~, N] = size(X);
MaxF = max(F); 
Mall = NaN(MaxF, 1); 
for f=1:MaxF
   Mall(f) = sum(F==f); 
end

% Get the number of object-clusters
MaxGall = NaN(MaxF, 1);
for f=1:MaxF
    MaxGall(f) = max(Z{f});
end

% Get the number of feature-clusters
MaxCall = NaN(MaxF, 1);
for f=1:MaxF
    MaxCall(f) = max(V{f});
end

% Get the size of membership for each object-cluster
Ngall = cell(MaxF, 1);
for f=1:MaxF
    if f==view2
        Ngall{f} = accumarray(Z{f}, 1);
        Ngall{f} = Ngall{f}';
    end
end

% Get the size of membership for each feature-cluster%
Ncall = cell(MaxF, 1);
for f=1:MaxF
    if f==view2
        Ncall{f} = accumarray(V{f}', 1);
        Ncall{f} = Ncall{f}';
    end
end

N1 = cell(MaxF, 1);
for f=1:MaxF
    if f==view2
        N1{f} = nan(MaxGall(f), MaxCall(f));
    end
end

for f = 1:MaxF
 if f==view2
    selectf = find(F==f);
    for g = 1:MaxGall(f)
        z_mask = (Z{f} == g);
        for c = 1:MaxCall(f)
            v_mask = (V{f} == c);
            if length(v_mask)>0
                X1_zv = X(selectf(v_mask),selectf(v_mask), z_mask);
                N1{f}(g,c) = getsumgeoWish2(X1_zv, T1, keepgammlan);
            else 
                N1{f}(g,c) = 0;
            end
        end
    end
  end
end

LJP = 0;
for f =1:MaxF
  if f==view2
    LJP = LJP + sum(N1{f}(:)) ...
        + MaxGall(f) * log(ALPHA0) + gammaln(ALPHA0) - gammaln(ALPHA0 + N) + sum(gammaln(Ngall{f})) ...
        + MaxCall(f) * log(BETA0) + gammaln(BETA0) - gammaln(BETA0 + Mall(f)) + sum(gammaln(Ncall{f}));
  end
end

end

