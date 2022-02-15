function X = preprocess(X, param)
% This performs pre-process of X: regularization and whitening

% Reguralization
[~, p, n] = size(X);
d = param.d; % regularization strength
for i=1:n
    X(:, :, i) = (X(:, :, i) + d*eye(p))/(1+d); % To make diagonal one
end

% Whitening
if param.white
    X = whiteCov(X);
end

end