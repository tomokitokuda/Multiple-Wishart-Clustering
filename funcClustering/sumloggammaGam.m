function sum2 = sumloggammaGam(T, p, keepgammlan)

temp2 = (T-(1:p)+1)/2;
sum2 = sum(keepgammlan(2*temp2));

end
