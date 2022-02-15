function keepgammlan = getkeepgammaln(upper2)

maxp = upper2;
keepgammlan = NaN(maxp, 1);
for i=1:maxp
    temp = i/2;
    keepgammlan(i) = gammaln(temp);
end

end