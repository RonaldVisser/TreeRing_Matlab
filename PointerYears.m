function PointerYrs=PointerYears(seriesmatrix)
% Weiserjahrestatistik / Pointer year analysis volgens Riemer(1994,
% 119-131) en Meyer(1999, op 195 formule, discussie PS beste; 199-200)
% PSi=(mean(i)*log(n)i)/stdev(i)
% PSi = indexed value for year i
% i = year in focus
% mean(i) = mean for year i
% n = number of samples for year i
% calculation for series in matrix
[h, b]=size(seriesmatrix);
mean0var1series=mean0var1(seriesmatrix);
meani=zeros(1,h);
n=zeros(1,h);
stdevi=zeros(1,h);
PSi=zeros(1,h);
for i=1:b
    meani(i)=nanmean(mean0var1series(2:end,i));
    n(i)=sum(~isnan(mean0var1series(2:end,i)));
    stdevi(i)=nanstd(mean0var1series(2:end,i));
end
PSi=((log10(n)).*meani)./stdevi;
PointerYrs.Dates=mean0var1series(1,:);
PointerYrs.Meani=meani;
PointerYrs.n=n;
PointerYrs.Stdevi=stdevi;
PointerYrs.PSi=PSi;