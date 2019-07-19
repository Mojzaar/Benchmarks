function sigLevel_p1= alphaCP(T_pirim,Nk_p1,b_p1)
if T_pirim / Nk_p1 < b_p1
    a = 0;
    b =b_p1;% interval [0 b]
else
    a = b_p1;
    b = 1; % interval [b 1]
end
if T_pirim == 0
    Alpha_p1 = (1 - a)^Nk_p1 - (1 - b)^Nk_p1;
elseif T_pirim == Nk_p1
    Alpha_p1 = b^Nk_p1-a^Nk_p1;
else
    alpha_a1 = T_pirim;
    beta_a1 = Nk_p1 - T_pirim +1;
    alpha_b1 = T_pirim +1;
    beta_b1 = Nk_p1 - T_pirim;
    pd_a1 = makedist('Beta','a',alpha_a1,'b',beta_a1);
    pd_b1 = makedist('Beta','a',alpha_b1,'b',beta_b1);
    Alpha_p1 = cdf(pd_b1,b) - cdf(pd_a1,a);
end
sigLevel_p1 = 1 - Alpha_p1;
end