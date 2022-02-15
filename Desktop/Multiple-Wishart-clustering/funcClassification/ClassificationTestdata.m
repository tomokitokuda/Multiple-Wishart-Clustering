function predtest = ClassificationTestdata(Model, Xtrain, Xtest, view2)
% This classifies a realization of correlation matrix into clusters yielded
% for Xtrain.
% Input: Model: model yielded by runMultipleWishart
%        Xtrain: p x p x n correlations matrices that were used to obtain the aforomentioned Model
%        Xtest: p x p correlation matrix to classify
%        view2: View ID in question
% Outpt: predtest: a scalar of integer, which denotes a cluster membership for Xtest        


% Add dumy
Model.Z{view2} = [Model.Z{view2}; nan];

X = cat(3, Xtrain, Xtest); % The test is the last one
[~, ~, N] = size(X);
Z = Model.Z;
V = Model.V;
F = Model.F; 

ALPHA0 = Model.options.ALPHA0;
T1 = Model.T1;

MaxF = max(F);
MaxGall = NaN(MaxF, 1);
for f=1:MaxF
    MaxGall(f) = max(Z{f});
end
MaxCall = NaN(MaxF, 1);
for f=1:MaxF
    MaxCall(f) = max(V{f});
end

% Update objects and features for each view
f = view2;
LJPview = [];
g_old = Z{f}(N);

%%% No emtpy clusters in the prediction
MaxGall(f) = MaxGall(f) + 1; % Increase one cluster
if isempty(LJPview)~=1
    LJPview(MaxGall(f)) = nan;
end
g_old2 = g_old;

tempZ = Z;
tempZ{f}(N) = nan;
if isempty(LJPview)==1
    LJPview = NaN(MaxGall(f), 1); % Each view, without the target features
    for g = 1:MaxGall(f)
        LJPview(g) = evalLJPviewselectObjectselectClassify(g, f, X, tempZ, V, F, T1);
    end
else
    LJPview(g_old2) = evalLJPviewselectObjectselectClassify(g_old2, f, X, tempZ, V, F, T1);
    if g_old2~=MaxGall(f)
        LJPview(MaxGall(f)) = evalLJPviewselectObjectselectClassify(MaxGall(f), f, X, tempZ, V, F, T1);
    end
end

% Compute the log joint pdf (LJP) for each candidate
LJPtmp = -inf(MaxGall(f),1);
LJPskeep = cell(MaxGall(f), 1);
for g = 1:MaxGall(f)
    Z{f}(N) = g;
    Ngall = accumarray(Z{f}, 1);
    Ngall = Ngall';
    Ngall(Ngall==0) = [];
    MaxGthis = max(Z{f});
    LJPprior = MaxGthis*log(ALPHA0) + gammaln(ALPHA0) - gammaln(ALPHA0 + N) + sum(gammaln(Ngall));
    LJPs = evalLJPviewselectObjectselectClassify(g, f, X, Z, V, F, T1);
    LJPskeep{g} = LJPs;
    LJPtmp(g) = LJPs + sum(LJPview(setdiff(1:MaxGall(f), g))) + LJPprior; % add the remainder of views
end

% Compute the probability to select the new cluster index
logProb = LJPtmp - max(LJPtmp);
Prob = exp(logProb);
[~, g_new] = nanmax(Prob);
predtest = g_new;

end

