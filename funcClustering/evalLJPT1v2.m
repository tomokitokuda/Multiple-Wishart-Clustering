function LJP = evalLJPT1v2(X, Z, V, F, ALPHA0, BETA0, GAMMA0, T1, keepgammlan, logdetXsum)

[~, M, N] = size(X);
MaxF = max(F); % Max number of views

Mall = NaN(MaxF, 1); % The number of features in each view
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
    Ngall{f} = accumarray(Z{f}, 1);
    Ngall{f} = Ngall{f}';
end

% Get the size of membership for each feature-cluster
Ncall = cell(MaxF, 1);
for f=1:MaxF
    Ncall{f} = accumarray(V{f}', 1);
    Ncall{f} = Ncall{f}';
end

N1 = cell(MaxF, 1);
for f=1:MaxF
    N1{f} = nan(MaxGall(f), MaxCall(f));
end

for f = 1:MaxF
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

LJP = MaxF*log(GAMMA0) + gammaln(GAMMA0) - gammaln(GAMMA0 + M) + sum(keepgammlan(2*Mall));

for f =1:MaxF
    LJP = LJP + sum(N1{f}(:)) ...
        + MaxGall(f) * log(ALPHA0) + gammaln(ALPHA0) - gammaln(ALPHA0 + N) + sum(keepgammlan(2*Ngall{f})) ...
        + MaxCall(f) * log(BETA0) + gammaln(BETA0) - gammaln(BETA0 + Mall(f)) + sum(keepgammlan(2*Ncall{f}));
end

sum2 = ((T1-M-1)/2)*logdetXsum - N*(M*T1/2)*log(2) - N*(M*(M-1)/4)*log(pi) - N*sumloggammaGam(T1, M,  keepgammlan);
LJP = LJP + sum2;

end

