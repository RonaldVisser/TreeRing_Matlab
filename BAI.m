% BAI op basis Haneca(2005)
% BAI(i)= pi * (R(i)² - R(i-1)²)
% R(i) is the sum of all ringwidths up to growth ring in year i
function BAIValues=BAI(series)
for i=1:length(series);
    if i==1
        BAIValues(i)=pi*(series(i)^2);
    else
        SumStart=sum(series(1:i-1));
        SumEnd=sum(series(1:i));
        BAIValues(i)=pi*(SumEnd^2 - SumStart^2);
    end
end