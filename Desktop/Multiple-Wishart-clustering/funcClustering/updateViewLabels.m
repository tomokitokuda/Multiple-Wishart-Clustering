function [F, Z, V, MaxF, MaxGall, MaxCall] = updateViewLabels(X, F, Z, V, M, N,  MaxF, MaxGall, MaxCall, hypall, T1, keepgammlan)

% Update view membership of features
ALPHA0 = hypall.ALPHA0;
BETA0 = hypall.BETA0;
GAMMA0 = hypall.GAMMA0; 

LJPview = [];
Msamp = randsample(1:M, M, false);
for ff=Msamp % Randome Loop for features
    Zpre = Z;
    Vpre = V;
    Fpre = F;
    LJPviewKept = LJPview;
    MaxCallpre = MaxCall;
    MaxGallpre = MaxGall;
    f_old = F(ff);
    Nf = sum(F == f_old);
    if Nf == 1
        fmask = (F == MaxF);
        F(fmask) = f_old; % MaxGall{f} has gone.
        Z{f_old} = Z{MaxF};
        V{f_old} = V{MaxF};
        if isempty(LJPview)~=1
            LJPview(f_old) = LJPview(MaxF);
        end
        f_old2 = MaxF; % Suppose the target is in view MaxF
        MaxCall(f_old) = MaxCall(MaxF);
        MaxGall(f_old) = MaxGall(MaxF);
        
        V{MaxF} = [];
        Z{MaxF} = transpose(getCRPsamples(N, ALPHA0)); % random parcellation
        MaxGall(MaxF) = max(Z{MaxF});
        MaxCall(MaxF) = 1;
        if isempty(LJPview)~=1
            LJPview(MaxF) = nan;
        end
    else
        MaxF = MaxF + 1; % Increase one cluster (empty cluster)
        findff = find(F==f_old);
        findff2 = find(findff==ff);
        c_old = V{f_old}(findff2);
        V{f_old}(findff2) = []; 
        
        % Adjust for feature cluster
        Nc = sum(V{f_old} == c_old);
        if Nc == 0 
            vmask = (V{f_old} == MaxCall(f_old));
            V{f_old}(vmask) = c_old;
            MaxCall(f_old) = MaxCall(f_old) - 1;
        end
        f_old2 = f_old;
        
        % For increased one
        V{MaxF} = [];
        Z{MaxF} = transpose(getCRPsamples(N, ALPHA0)); % random parcellation
        MaxGall(MaxF) = max(Z{MaxF});
        MaxCall(MaxF) = 1;
        if isempty(LJPview)~=1
            LJPview(MaxF) = nan;
        end
    end
    tempF = F;
    tempF(ff) = nan;
    tempV = V;
    if isempty(LJPview)==1
        LJPview = NaN(MaxF, 1); % Each view, without the target features
        for f=1:MaxF
            LJPview(f) = evalLJPviewselect(f, X, Z, tempV, tempF, ALPHA0, BETA0, T1, keepgammlan);
        end
    else % Update only the target view
        LJPview(f_old2) = evalLJPviewselect(f_old2, X, Z, tempV, tempF, ALPHA0, BETA0, T1, keepgammlan);
        if f_old2~=MaxF
            LJPview(MaxF) = evalLJPviewselect(MaxF, X, Z, tempV, tempF, ALPHA0, BETA0, T1, keepgammlan);
        end
    end
    
    F(ff) = nan; % F is ok, but V has no ff feature
    Mall = NaN(MaxF, 1); % The number of features in each view
    for s=1:MaxF
        Mall(s) = sum(F==s);
    end
    
    LJPskeep = cell(MaxF, 1);
    LJPtmp= [];
    add2 = NaN(MaxF, 1);
    for f=1:MaxF
        F(ff) = f;
        Mall = hist(F,unique(F));
        LJPprior = MaxF*log(GAMMA0) + gammaln(GAMMA0) - gammaln(GAMMA0 + M) + sum(gammaln(Mall));
        LJPs = evalLJPviewselect2(X, Z, V, F, ALPHA0, BETA0, MaxCall, f, ff, T1,  keepgammlan); % view select
        LJPskeep{f} = LJPs;
        LJPs = LJPs + sum(LJPview(setdiff(1:MaxF, f))) + LJPprior; % add the remainder of views
        LJPtmp = [LJPtmp; LJPs];
        add2(f) = length(LJPs);
    end
    
    % Compute the probability to select the new cluster index
    logProb = LJPtmp - max(LJPtmp);
    Prob = exp(logProb);
    [~, f_new] = nanmax(Prob);
    LLpost = LJPtmp(f_new);
    
    % Update the cluster assignment, LJP & the number of cluster
    [viewid, featid] = findviewf(add2, f_new);

    % Update F
    F(ff) = viewid;
    
    % Updata V
    if viewid==MaxF
        V{viewid} = 1;
        % Update LJPview
        LJPview(viewid) = LJPskeep{viewid};
    else
        vdall = find(F==viewid);
        [a, ~] = sort(vdall, 'ascend');
        k = find(a==ff); % Position of feature featid in the view
        V{viewid} = insertelement(V{viewid}, k, featid); % Insert value c at position k
        
        % Update LJPview
        LJPview(viewid) = LJPskeep{viewid}(featid);
    end
    
    % Insert this for V
    if viewid ~= MaxF %& length(V)<MaxF
        MaxF = MaxF - 1;
        MaxCall(end) = [];
        MaxGall(end) = [];
        V(end) = [];
        Z(end) = [];
        LJPview(end) = [];
    end
    
    LLpre = evalLJPT1(X, Zpre, Vpre, Fpre, ALPHA0, BETA0, GAMMA0, T1, keepgammlan);
    if LLpre>LLpost
        Z = Zpre;
        V = Vpre;
        F = Fpre;
        LJPview = LJPviewKept;
        MaxF = max(F);
        MaxCall = MaxCallpre;
        MaxGall = MaxGallpre;
    end
end
end