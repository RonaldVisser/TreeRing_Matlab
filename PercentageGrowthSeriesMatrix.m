function PercentageGrowthSeries_Mtx=PercentageGrowthSeriesMatrix(seriesmatrix)
[x y]=size(seriesmatrix);
PercentageGrowthSeries_Mtx=nan(x,y);
PercentageGrowthSeries_Mtx(1,:)=seriesmatrix(1,:);
for i=2:x
    PercentageGrowthSeries_Mtx(i,:)=PercentageGrowthSeries(seriesmatrix(i,:));
end