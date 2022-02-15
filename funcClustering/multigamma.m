function add3 = multigamma(a, p, keepgammlan)
% This is for evaluation of multiple gamma function

add3 = (p*(p-1)/4)*log(pi) + sum(keepgammlan(2*(a + (1-(1:p))/2)));

end
