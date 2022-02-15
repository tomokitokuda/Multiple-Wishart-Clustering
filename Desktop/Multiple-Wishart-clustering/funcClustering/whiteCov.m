function covall2 = whiteCov(covall)
% Whitening all covariances by thier average
% Input: p x p x n matrices where it consists of n realizations of 
% p x p correlation (covaraince)    
% Ouput: p x p x n matrices where each realization is whitened by the
% average of all realizations.

covmean =mean(covall, 3);
[V,D] = eig(covmean);
Ds = sqrt(D);
Ds2 = zeros(size(Ds));
[p, ~, n] = size(covall);

for i=1:p
    Ds2(i, i) = 1/Ds(i, i);
end

DD = V*Ds2*V';
covall2 = NaN(size(covall));
for i=1:n
    covall2(:, :, i) = corrcov(DD*covall(:, :, i)*DD);
end


end
