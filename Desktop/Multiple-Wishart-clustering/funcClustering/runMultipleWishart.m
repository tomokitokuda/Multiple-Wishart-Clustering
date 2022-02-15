function  Model = runMultipleWishart(X, param)
% INPUT
% X: p x p x N, dataset of correlation matrices with p x p correlation
%    matrix and N objects.
% param: setting of the algorith. This is an object of setParam.m
% OUTPUT
% Model.F: p x 1 vector that denotes view membership of nodes  
% Model.Z{i}: N x 1 vector that denotes object cluster membership in
%             view i.
% Model.V{i}: q(i) x 1 vector that denotes node cluster membership of nodes in view i
%    where q(i) is the number of nodes included in that view. Note that the 
%    node ID can be obtained using Model.F. You may refer to
%    view{i}.features that is yielded by view = summaryModel(Modelf).This 
%    provides more straignforward representation of node cluster
%    memberships
% Model.T1: Estimate of degree of freedom for Wishart distribution 
% Model.LJP: The value of logarithm of joint posterior that is optimized. 
% Model.options: The setting of parameters used.

if nargin==1
    param = setParam('T1', 2*size(X, 1));
end

% Pre-process
X = preprocess(X, param);


% Setting the seed
seednum = param.seednum;
s = RandStream('mrg32k3a', 'seed', seednum);
RandStream.setGlobalStream(s);

% Parameters
MaxIter = param.MaxIter;
maxsilence = param.maxsilence;

% Output 
Model.X = X;
Model.F = [];
Model.Z = [];
Model.V = [];
Model.T1ori = param.T1;
Model.T1 = param.T1; % This will be updated
Model.LJP = -inf;
Model.options = param;

%% Pre-calculation of logarithm gamma function in advance (for fast calculations)
[~, M, N] = size(Model.X);
upper2 = (Model.T1ori)*N + M + 100; % instead of 4, set to 100
Model.keepgammlan =  getkeepgammaln(upper2);

%% Pre-calculation of the sum of the logarithm of matrix determinant in advance (for fast calculation)
logdetXsum = 0;
for i=1:N
    logdetXsum = logdetXsum + logdet(Model.X(:, :, i), 'chol');
end
Model.logdetXsum = logdetXsum;
clear logdetXsum;
%% Copy the initial model to a candidate model.
candModel = Model;

%% Inferences
ok = 1;
countRep = 0;
countNoImp = 0;
while ok==1
    countRep = countRep + 1; % Count how many repetitions
    countNoImp = countNoImp + 1; % Count how many no update
 
    ffn = sprintf('Run %d out of %d', countRep, MaxIter);
    disp(ffn);

    % Main function     
    candModel = updateAllLabels(candModel);
    candModel.Iteration = countRep; 
    
    if (candModel.LJP - Model.LJP)> 0.00001
        Model = candModel;
        countNoImp = 0; % Reset counts of non-improvement case
    end
    
    if countRep == MaxIter || countNoImp == maxsilence
        ok = 0; % Leave the loop
    end
end

% Remove unnecessary parts
Model = rmfield(Model,{'X', 'keepgammlan','logdetXsum', 'T1ori', 'Iteration'});

len2 = length(Model.V);
for i=1:len2
    Model.V{i} = Model.V{i}'; % simply transpose the outcome
end

end
