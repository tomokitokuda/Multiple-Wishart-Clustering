function res = getsumgeoWish2subjectClassify(x, T)

[p, ~, n] = size(x);
nu2 = p+3;% hyperparameters for inverse Wishart
nu22 = T*n + nu2;
logB = ((nu22*p)/2)*log(2) + multigammaClassify(nu22/2, p) - (nu22/2)*log(det(sum(x, 3) + ((nu2 - p -1)/T)*eye(p)));
res = logB;

end
