function CompareSampleMeanRest(seriesmatrix, A, label)
    [x y]=size(seriesmatrix);
    if A==x
        newseriesmatrix=[seriesmatrix(1:A-1,:)];
    else
        newseriesmatrix=[seriesmatrix(1:A-1,:); seriesmatrix(A+1:end,:)];
    end
    MeanCurveOtherSeries=MeanCurve(newseriesmatrix);
    TempMatrix=[MeanCurveOtherSeries(1:2,:); seriesmatrix(A,:); MeanCurveOtherSeries(3,:)];
    Temp2Matrix=TempMatrix(:, ~isnan(seriesmatrix(A,:)));
    newlabels=['MeanCurveOtherSeries';label(A-1)];
    dendroplot(Temp2Matrix, 2 ,3, newlabels);
    hold on;
    ax1 = gca;
    ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right',...
           'Color','none',...
           'XLim',[min(Temp2Matrix(1,:)) max(Temp2Matrix(1,:))],...
           'YLim', [0 (max(Temp2Matrix(4,:))*5)],'YColor','r');
    hl2 = line(Temp2Matrix(1,:),Temp2Matrix(4,:),'Color','r','Parent',ax2);    
end
