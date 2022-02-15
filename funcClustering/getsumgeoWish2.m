function [res,n] = getsumgeoWish2(x, T, keepgammlan)

[p, ~, n] = size(x);
nu2 = p+3;
logC =  (nu2*p/2)*log(2) + multigamma(nu2/2, p, keepgammlan);
nu22 = T*n + nu2;

if p>20
    logB = ((nu22*p)/2)*log(2) + multigamma(nu22/2, p, keepgammlan) - (nu22/2)*logdet(sum(x, 3) + ((nu2 - p -1)/T)*eye(p), 'chol');
else
   logB = ((nu22*p)/2)*log(2) + multigamma(nu22/2, p, keepgammlan) - (nu22/2)*log(det(sum(x, 3) + ((nu2 - p -1)/T)*eye(p)));
end

logD = (nu2*p/2)*log((nu2-p-1)/T); % Changed
res = logB - logC + logD;

end
