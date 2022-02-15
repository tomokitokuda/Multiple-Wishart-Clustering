function [res, n] = getsumgeoWish2subject(x, T, keepgammlan)
% x is p x p x n matrix
% T is the degree of freedom for correation matirx. It corresponds the time
% period.

[p, ~, n] = size(x);
nu2 = p+3;
nu22 = T*n + nu2;

if p>20
    logB = ((nu22*p)/2)*log(2) + multigamma(nu22/2, p, keepgammlan) - (nu22/2)*logdet(sum(x, 3) + ((nu2 - p -1)/T)*eye(p), 'chol');
else
   logB = ((nu22*p)/2)*log(2) + multigamma(nu22/2, p, keepgammlan) - (nu22/2)*log(det(sum(x, 3) + ((nu2 - p -1)/T)*eye(p)));
end

res = logB;

end
