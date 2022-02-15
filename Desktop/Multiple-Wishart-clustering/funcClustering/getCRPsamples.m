function Z = getCRPsamples(N, Alpha)
% This is for random sampling of CRP (Chinese Restaurant Process)
% Input: N, sample size
%        Alpha, concentration parameter
% Output: A realization of clustering of N objects

Z = nan(1,N);
Nc = zeros(1,N);
MaxC = 0;
for nn = 1:N
    prob_birth = Alpha/(nn-1+Alpha);
    if rand < prob_birth
        MaxC = MaxC + 1;
        Z(nn) = MaxC;
        Nc(MaxC) = 1;
    else
        idx = randsample(MaxC, 1, true, Nc(1:MaxC));
        Z(nn) = idx;
        Nc(idx) = Nc(idx) + 1;
    end
end

end
