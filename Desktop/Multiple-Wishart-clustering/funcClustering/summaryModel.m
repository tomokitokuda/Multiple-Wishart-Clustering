function view = summaryModel(model)
% This function summarizes results of clustering by the multiple clustering
% method based on Wishart mixture models
% Input: esimtaed model yielded by runMultipleWishart.m
%
% Output: view and clustering results 
% view{v} contains results of feature clustering and object clustering in
%         view v. The following structure is provided:
%      view{v}.objects: object cluster memberships          
%      view{v}.feature: feature cluster memberships    
%      
%  Note 1: Cluster memberships are given by positive integers.  
%       2: If a feature membership is zero in view{v}, the feature does not 
%          belong to view v.

numview = max(model.F);
sprintf('The number of views : %d', numview)

p = length(model.F); 
view = cell(1, numview);
for i=1:numview
    view{i}.objects = model.Z{i};
    temp = zeros(p, 1); % all zeros
    temp(model.F==i) = model.V{i}; % For nodes in view i, replace zeros with those feature clusrer ID
    view{i}.features = temp;
end

end