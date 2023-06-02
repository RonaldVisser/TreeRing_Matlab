% compare series with mean
Selection=menu('Compare Single Series with Mean of the rest',label);
m0v1series=mean0var1(seriesmatrix);
m0v1series(2:end,:)=(m0v1series(2:end,:)+10)*10;
CompareSampleMeanRest(m0v1series, Selection+1, label);
%CompareSampleMeanRest(seriesmatrix, Selection+1, label);