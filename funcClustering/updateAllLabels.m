function  Model = updateAllLabels(Model)

% Get data and view/cluster assignments
X = Model.X;
[~, M, N] = size(X);
F = Model.F; % view membership
Z = Model.Z; % object-cluster
V = Model.V; % feature-cluster
T1 = Model.T1; % degree of freedom (would be updated)
T1ori = Model.T1ori; % degree of freedom (fixed)

% Get hyper-parameters
hypall.ALPHA0 = Model.options.ALPHA0;
hypall.BETA0 = Model.options.BETA0;
hypall.GAMMA0 = Model.options.GAMMA0; 

% Pre-calculated part
keepgammlan = Model.keepgammlan;
logdetXsum = Model.logdetXsum;

% Initialize the view assignment if it's uninitialized
fclusterone = Model.options.fclusterone;
[F, Z, V, MaxF, MaxGall, MaxCall] = initialization(F, Z, V, M, N, hypall, fclusterone);

%% Updating 
% View membership of features
[F, Z, V, MaxF, MaxGall, MaxCall] = updateViewLabels(X, F, Z, V, M, N,  MaxF, MaxGall, MaxCall, hypall, T1, keepgammlan);

% Objects and features for each view
for f=1:MaxF    
    [F, Z, V, MaxF, MaxGall, MaxCall] = updateObjectLabels(f, X, F, Z, V, N, MaxF, MaxGall, MaxCall, hypall, T1, keepgammlan);
    [F, Z, V, MaxF, MaxGall, MaxCall] = updateFeatureLabels(f, X, F, Z, V, MaxF, MaxGall, MaxCall, hypall, T1, keepgammlan);
end 

% Degree of freedom
[T1, LJP] = updateDegreeFreedom(X, F, Z, V, M, T1ori, hypall, keepgammlan, logdetXsum);

%% Keep the resultls in Model
Model.Z = Z;
Model.V = V;
Model.F = F;
Model.T1 = T1;

% log-posterior
Model.LJP = LJP;

disp(LJP);

end

