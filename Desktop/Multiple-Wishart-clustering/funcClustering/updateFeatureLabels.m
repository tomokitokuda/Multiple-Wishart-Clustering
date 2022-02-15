function [F, Z, V, MaxF, MaxGall, MaxCall] = updateFeatureLabels(f, X, F, Z, V, MaxF, MaxGall, MaxCall, hypall, T1, keepgammlan)

ALPHA0 = hypall.ALPHA0;
LJPview = [];
Vran = randsample(1:length(V{f}),  length(V{f}), false);
for jj = Vran
    NN = length(V{f});
    if length(V{f})>1 % if there is only one feature in the view, skip the followin
        c_old = V{f}(jj);
        Nc = sum(V{f} == c_old);
        if Nc == 1
            vmask = (V{f} == MaxCall(f));
            V{f}(vmask) = c_old;
            c_old2 = MaxCall(f);
            if isempty(LJPview)~=1
                LJPview(c_old) = LJPview(MaxCall(f));
                LJPview(MaxCall(f)) = nan;
            end
        else
            MaxCall(f) = MaxCall(f) + 1;
            if isempty(LJPview)~=1
                LJPview(MaxCall(f)) = nan;
            end
            c_old2 = c_old;
        end
        
        % Compute the log joint pdf (LJP) for each candidate
        tempV = V;
        tempV{f}(jj) = nan;
        if isempty(LJPview)==1
            for c = 1:MaxCall(f)
                LJPview(c) = evalLJPviewselectFeatureselect(c, f, X, Z, tempV, F, T1, keepgammlan);
            
            end
        else
            LJPview(c_old2) = evalLJPviewselectFeatureselect(c_old2, f, X, Z, tempV, F, T1, keepgammlan);
            if c_old2~=MaxCall(f)
                LJPview(MaxCall(f)) = evalLJPviewselectFeatureselect(MaxCall(f), f, X, Z, tempV, F, T1, keepgammlan);
            end
        end
        
        LJPtmp = -inf(MaxCall(f),1);
        LJPskeep = cell(MaxCall(f), 1);
        for c = 1:MaxCall(f)
            V{f}(jj) = c;
            Ncall = accumarray(V{f}', 1);
            Ncall = Ncall';
            Ncall(Ncall==0) = [];
            MaxCthis = max(V{f});
            LJPprior =  MaxCthis*log(ALPHA0) + gammaln(ALPHA0) - gammaln(ALPHA0 + NN) + sum(gammaln(Ncall));
            LJPs = evalLJPviewselectFeatureselect(c, f, X, Z, V, F, T1, keepgammlan);
            LJPskeep{c} = LJPs;
            LJPtmp(c) = LJPs + sum(LJPview(setdiff(1:MaxCall(f), c))) + LJPprior; % add the remainder of views
        end
        % Compute the probability to select the new cluster index
        logProb = LJPtmp - max(LJPtmp);
        Prob = exp(logProb);
        [~, c_new] = nanmax(Prob);
        
        % Update the cluster assignment, LJP & the number of clusters
        V{f}(jj) = c_new;
        LJPview(c_new) = LJPskeep{c_new};
        if c_new ~= MaxCall(f)
            MaxCall(f) = MaxCall(f) - 1;
            LJPview(end) = [];
        end
    end
end 
end