function add3 = multigammaClassify(a, p)

add3 = (p*(p-1)/4)*log(pi) + sum(gammaln(a + (1-(1:p))/2));

end
