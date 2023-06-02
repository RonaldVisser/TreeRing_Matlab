function [Y] = meanadjust(X);
% Deze functie trekt het gemiddelde af van een serie ringbreedtes.
meanX=nanmean(X);
Y=X-meanX;