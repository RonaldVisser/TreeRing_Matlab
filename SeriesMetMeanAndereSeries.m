% all series with mean rest
[x y]=size(seriesmatrix);
Vergelijking(1,:)={'Mean' 'Dendro' 'overlap' 'r' 'r(wuchs)' 't' 't(wuchs)' 'SGC' 'SSGC' 'p' 'p_glk'};
for A=2:x
    if A==x
        newseriesmatrix=[seriesmatrix(1:A-1,:)];    
    else
        newseriesmatrix=[seriesmatrix(1:A-1,:); seriesmatrix(A+1:end,:)];
    end
    MeanCurveOtherSeries=MeanCurve(newseriesmatrix);
    TempMatrix=[MeanCurveOtherSeries(1:2,:); seriesmatrix(A,:); MeanCurveOtherSeries(3,:)];
    comparing=TempMatrix(:, ~isnan(seriesmatrix(A,:)));
    newlabels=['MeanCurveOtherSeries';label(A-1)];
    [n nSGC nSSGC SGC SSGC]=SGC_series(comparing(2,:), comparing(3,:), 25);
    if ~isnan(nSGC) && SGC > 50
        [nr r]=correlatie(comparing(2,:),comparing(3,:),20);
        [nwr wr]=correlatie(wuchswerte(comparing(2,:)),wuchswerte(comparing(3,:)),25);
        [nt t]=tvalue(comparing(2,:),comparing(3,:),25);
        [nwt wt]=tvalue(wuchswerte(comparing(2,:)),wuchswerte(comparing(3,:)),25);
        s=1/(2*sqrt(n));
        z=((SGC/100)-0.495)/s;
        z_glk=(((SGC+(SSGC/2))/100)-0.5)/s;
        p_glk=2*(1-normcdf(z_glk,0,1));
        p=2*(1-normcdf(z,0,1));
        Vergelijking(A,:)=[newlabels(2) newlabels(1) nr r wr t wt SGC SSGC p p_glk];
    end
end

laagsteSGC = min(cell2mat(Vergelijking(2:end,8)));

fprintf('%s%s%4.2f%s\n',label{find(cell2mat(Vergelijking(2:end,8))==laagsteSGC)}, ' heeft de laagste SGC: ', laagsteSGC, '%')
CompareSampleMeanRest(seriesmatrix,find(cell2mat(Vergelijking(2:end,8))==laagsteSGC), label);


