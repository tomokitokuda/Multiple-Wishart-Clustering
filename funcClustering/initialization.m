function [F, Z, V, MaxF, MaxGall, MaxCall] = initialization(F, Z, V, M, N, hypall, fclusterone)
% This is for initialization and calculate the number of views and clusters for both initialized
% and non-initialized cases
% Input: View/cluster meberships (F, Z, V), data size (M, N),hyperparameters (hypall)
%        and option on initial feautre clusters (fclusterone)
% Output: Initialized F, Z, and V; maximum number of views/clusters.
%        Note that F, Z, V are initialized only when F is empty

GAMMA0 = hypall.GAMMA0;
ALPHA0 = hypall.ALPHA0;
BETA0 = hypall.BETA0;

if isempty(F)
    % Feature view membership
    F = transpose(getCRPsamples(M, GAMMA0));
    MaxF = max(F);
    
    % Object cluster membership
    MaxGall = NaN(MaxF, 1);
    for f=1:MaxF
        Z{f} = transpose(getCRPsamples(N, ALPHA0));
        MaxGall(f) = max(Z{f});
    end
    
    % Feature cluster membership
    MaxCall = NaN(MaxF, 1);
    for f=1:MaxF
        Mtemp = sum(F==f); % Number of features
        if fclusterone==1 % Initial number of feature clusters
            V{f} = ones(1, Mtemp);
        else
            V{f} = getCRPsamples(Mtemp, BETA0);
        end
        MaxCall(f) = max(V{f});
    end

else
    MaxF = max(F);
    MaxGall = NaN(MaxF, 1);
    for f=1:MaxF
        MaxGall(f) = max(Z{f});
    end
    MaxCall = NaN(MaxF, 1);
    for f=1:MaxF
        MaxCall(f) = max(V{f});
    end
end

end