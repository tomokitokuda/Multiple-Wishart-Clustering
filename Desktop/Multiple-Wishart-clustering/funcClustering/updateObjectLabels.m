function [F, Z, V, MaxF, MaxGall, MaxCall] = updateObjectLabels(f, X, F, Z, V, N,  MaxF, MaxGall, MaxCall, hypall, T1, keepgammlan)

ALPHA0 = hypall.ALPHA0;
LJPview = [];
Nran = randsample(1:N, N, false);
for ii = Nran
    g_old = Z{f}(ii);
    Ng = sum(Z{f} == g_old);
    if Ng == 1
        zmask = (Z{f} == MaxGall(f));
        Z{f}(zmask) = g_old; % MaxGall{f} has gone.
        g_old2 = MaxGall(f);
        if isempty(LJPview)~=1
            LJPview(g_old) = LJPview(MaxGall(f));
            LJPview(MaxGall(f)) = nan;
        end
    else
        MaxGall(f) = MaxGall(f) + 1; % Increase one cluster
        if isempty(LJPview)~=1
            LJPview(MaxGall(f)) = nan;
        end
        g_old2 = g_old;
    end
    
    tempZ = Z;
    tempZ{f}(ii) = nan;
    if isempty(LJPview)==1
        LJPview = NaN(MaxGall(f), 1); % Each view, without the target features
        for g = 1:MaxGall(f) 
           LJPview(g) = evalJLPviewselectObjectselect(g, f, X, tempZ, V, F, T1,  keepgammlan);  
        end
    else
        LJPview(g_old2) = evalJLPviewselectObjectselect(g_old2, f, X, tempZ, V, F, T1,  keepgammlan);
        if g_old2~=MaxGall(f)
            LJPview(MaxGall(f)) = evalJLPviewselectObjectselect(MaxGall(f), f, X, tempZ, V, F, T1,  keepgammlan);

        end
    end
    
    % Compute the log joint pdf (LJP) for each candidate
    LJPtmp = -inf(MaxGall(f),1);
    LJPskeep = cell(MaxGall(f), 1);
    for g = 1:MaxGall(f)
        Z{f}(ii) = g;
        Ngall = accumarray(Z{f}, 1);
        Ngall = Ngall';
        Ngall(Ngall==0) = [];
        MaxGthis = max(Z{f});
        LJPprior = MaxGthis*log(ALPHA0) + gammaln(ALPHA0) - gammaln(ALPHA0 + N) + sum(gammaln(Ngall));
        LJPs = evalJLPviewselectObjectselect(g, f, X, Z, V, F, T1, keepgammlan);
        LJPskeep{g} = LJPs;
        LJPtmp(g) = LJPs + sum(LJPview(setdiff(1:MaxGall(f), g))) + LJPprior; % add the remainder of views
    end
    % Compute the probability to select the new cluster index
    logProb = LJPtmp - max(LJPtmp);
    Prob = exp(logProb);
    [~, g_new] = nanmax(Prob);

    % Update the cluster assignment, LJP & the number of clusters
    Z{f}(ii) = g_new;
    
    LJPview(g_new) = LJPskeep{g_new};
    if g_new ~= MaxGall(f)
        MaxGall(f) = MaxGall(f) - 1;
        LJPview(end) = [];
    end
end
end