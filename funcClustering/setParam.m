function options = setParam(varargin)

% Pre-process
options.d = 0; % regulazation strength (e.g., 0.05)
options.white = false; % whether whitening is performend

% Maximum number of iterations for Gibbs sampling
options.MaxIter = 100;

% Concentration parameter for object-cluster assignment
options.ALPHA0 = 1;

% Concentration parameter for feature-cluster assignment
options.BETA0 = 1;

% Concentration parameter for view assignment
options.GAMMA0 = 1;

% Random seed
options.seednum = 1;

% Degree of freedom
options.T1 = 60;

% Maximum number of non-improvement for parameter updates 
options.maxsilence = 10;

% Initial number of feature clusters
options.fclusterone = 1;

%% Return the default options if input argments are empty
if(isempty(varargin))
    return;
end

%% Change the options according to the input arguments
for k=1:2:length(varargin)
    fname = varargin{k};
    if(isfield(options,fname))
        value=varargin{k+1};
        options.(fname)=value;
    end
end

end
