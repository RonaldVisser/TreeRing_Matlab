maat=size(seriesmatrix);
Overzicht(1,:)={'Series' 'overlap' 'r' 'r(wuchs)' 't' 't(wuchs)' 'SGC' 'SSGC' 'p' 'p_glk'};
for i=2:maat(1)
    newseriesmatrix=[seriesmatrix(1:i-1,:); seriesmatrix(i+1:end,:)];
    MeanCurveOtherSeries=MeanCurve(newseriesmatrix);
    TempMatrix=[MeanCurveOtherSeries(1:2,:); seriesmatrix(i,:); MeanCurveOtherSeries(3,:)];
    Temp2Matrix=TempMatrix(:, ~isnan(seriesmatrix(i,:)));
    [nr r]=correlatie(Temp2Matrix(2,:),Temp2Matrix(3,:),20);
    [nwr wr]=correlatie(wuchswerte(Temp2Matrix(2,:)),wuchswerte(Temp2Matrix(3,:)),25);
    [nt t]=tvalue(Temp2Matrix(2,:),Temp2Matrix(3,:),25);
    [nwt wt]=tvalue(wuchswerte(Temp2Matrix(2,:)),wuchswerte(Temp2Matrix(3,:)),25);
    [n nSGC nSSGC SGC SSGC]=SGC_series(Temp2Matrix(2,:), Temp2Matrix(3,:), 25);
    s=1/(2*sqrt(nSGC));
    z=((SGC/100)-0.495)/s;
    z_glk=(((SGC+(SSGC/2))/100)-0.5)/s;
    p_glk=2*(1-normcdf(z_glk,0,1));
    p=2*(1-normcdf(z,0,1));
    Overzicht(i,:)=[label(i-1) nr r wr t wt SGC SSGC p p_glk];
end
clear p p_glk z_glk z s n nSGC nSSGC SGC SSGC nwt wt nt t nwr wr nr r Temp2Matrix TempMatrix MeanCurveOtherSeries newseriesmatrix
