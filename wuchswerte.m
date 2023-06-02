function [wuchswertseries]=wuchswerte(treeringseries)
% wuchswerte Hollstein(1980) Y(i)=100 ln (b(i)/b(i-1))
% to supress problems with first or last value a NaN is added to the end
% and the beginning of the series
treeringseries=[treeringseries NaN];
% shift series to create b(i-1)
tmpseries=[NaN treeringseries(1:length(treeringseries)-1)];
% transform series
wuchswertseries=100*log(treeringseries./tmpseries);
% shift series to correct earlier shift an simaltanously remove 1st and
% last NaN added earlier
wuchswertseries=wuchswertseries(1:end-1);