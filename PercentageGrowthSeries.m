function [PercentageGrowthChangeSeries]=PercentageGrowthSeries(series)
[x y]=size(series);
PercentageGrowthChangeSeries=nan(1,y);
for i=2:y
    PercentageGrowthChangeSeries(i)=series(i)/series(i-1);
end