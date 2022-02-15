%%% Demonstration of classification of test data, based on the clustering
%%% restuls of training data

%% Path setting
addpath('funcClassification');

%% Data
load('data/Data1.mat');

%% Yielded model
load('model/Model1.mat', 'Model');

%% Classificaiton
Xtrain = X;
Xtest = X; % This is usually different other than Xtrain. 
view2 = 1;
[~, ~, n] = size(X);
predtest = NaN(n, 1);
for i=1:n
    predtest(i) = ClassificationTestdata(Model, Xtrain, Xtest(:, :, i), view2);
end
crosstab(Model.Z{view2}, predtest)

