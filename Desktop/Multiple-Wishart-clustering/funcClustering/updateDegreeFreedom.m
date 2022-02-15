function [T1, LJP] = updateDegreeFreedom(X, F, Z, V, M, T1ori, hypall, keepgammlan, logdetXsum)

ALPHA0 = hypall.ALPHA0;
BETA0 = hypall.BETA0;
GAMMA0 = hypall.GAMMA0; 

num = 3;% steps
T1candi  = (M+5):num:T1ori;
num2 = length(T1candi);

res = NaN(num2, 1);
for i=1:num2
    res(i) = evalLJPT1v2(X, Z, V, F, ALPHA0, BETA0, GAMMA0, T1candi(i), keepgammlan, logdetXsum);
end

restt = res-nanmax(res);
restt2 = exp(restt);
pptt2 = restt2/sum(restt2);
[~, b] = nanmax(pptt2);
T1 = T1candi(b);
LJP = res(b);

end