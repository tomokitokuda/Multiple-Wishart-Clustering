function res = getsumgeoWish2Classify(x, T)

[p, ~, n] = size(x);
nu2 = p+3;% hyperparameters for inverse Wishart
logC =  (nu2*p/2)*log(2) + multigamma3Classify(nu2/2, p);
nu22 = T*n + nu2;
logB = ((nu22*p)/2)*log(2) + multigamma3Classify(nu22/2, p) - (nu22/2)*log(det(sum(x, 3) + ((nu2 - p -1)/T)*eye(p)));
logD = (nu2*p/2)*log((nu2-p-1)/T);
res = logB - logC + logD;

end
