% Correlatie berekening van jaarringen
function [n,r]=correlatie(X,Y,minoverlap);
L = ~isnan(X) & ~isnan(Y);
n = sum(L); % aantal overlappende ringen
if n < minoverlap;
    r=NaN;   %NaN;
else
    % Zorgen dat beide series een NaN hebben waar zij niet overlappen
    X(~L)=NaN;
    Y(~L)=NaN;
    % NaN verwijderen
    X=X(~isnan(X));
    Y=Y(~isnan(Y));
    % Gemiddeldes berekenen
    GemX=mean(X);
    GemY=mean(Y);
    % afwijkingen van gemiddelde berekenen
    DX = X-GemX;
    DY = Y-GemY;
    % correlatie
    r=(1/n)*sum((DX/sqrt(var(X))).*(DY/sqrt(var(Y))));
end
