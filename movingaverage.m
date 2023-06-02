function [movedseries]=movingaverage(series, year)
%series=series(~isnan(series));
switch year
    case 3
        for i=1:length(series)
            if isnan(series(i)) | ~isnan(i) && isnan(i-1) | ~isnan(i) && isnan(i+1)
                movedseries(i)=NaN;
            else
                movedseries(i)=0.25*series(i-1)+0.5*series(i)+0.25*series(i+1);
            end
        end
    case 5
        for i=3:length(series)-2
            if i==length(series)-2
                movedseries(i)=NaN;
                movedseries(i+1)=NaN;
                movedseries(i+2)=NaN;
            elseif isnan(series(i)) | ~isnan(i) && isnan(i-1) | ~isnan(i) && isnan(i+1) | ~isnan(i) && isnan(i-2) | ~isnan(i) && isnan(i+2);
                movedseries(i)=NaN;
            else 
                movedseries(i)=(series(i-2)+series(i-1)+series(i)+series(i+1)+series(i+2))/5;
            end
        end
end

