%%% Demonstration of clustering

%% Path setting
addpath('funcClustering');

%% Data
load('Data/Data1.mat', 'X', 'truelabel');

%% Parameter setting
T1 = 2*size(X, 1); % Initial degree of freedom
MM = 3; % Number of runs
MaxIter = 10; % Max number of iterations

%% Execution of the algorithm
maxLJP = -inf;
for m = 1:MM
  disp(m); 
  param = setParam('seednum', m, 'T1', T1, 'MaxIter', MaxIter);
  Model = runMultipleWishart(X, param);
  if Model.LJP > maxLJP
    maxLJP = Model.LJP;
    Modelfinal = Model;
  end
  clear Model;  
end 

%% Reuslts
view = summaryModel(Modelfinal);

viewnum = 1; % it can be 2 or 3
bar(view{viewnum}.features);
xlabel('Feature ID');
ylabel('Feature cluster ID '); % If a feature is not included, it is shownn as zero.
title(sprintf('Feature cluster: View %d', viewnum));
set(gca, 'FontSize', 16);
shg;

figure;
bar(view{viewnum}.objects);
xlabel('Object ID');
ylabel('Object cluster ID '); % If a feature is not included, it is shownn as zero.
title(sprintf('Object cluster: View %d', viewnum));
set(gca, 'FontSize', 16);
shg;

%% Comparison with the true label (stored in truelabel)
% Partition of nodes into views 
crosstab(truelabel.F, Modelfinal.F)

% Partition of objects
crosstab(truelabel.Z{1}, Modelfinal.Z{3})
crosstab(truelabel.Z{2}, Modelfinal.Z{1})
crosstab(truelabel.Z{3}, Modelfinal.Z{2})
