% correlation-matrix of columnwise treering file imported with YuxMatlab.m
% or with importrwl
function [overlap, correlations] = corrmatrix(seriesmatrix,minoverlap)
[a,b]=size(seriesmatrix);
% pre-allocate overlap and correlations
correlations=zeros(a-1,a-1);
overlap=zeros(a-1,a-1);
% start calculating all correlations and mirror all correlations along
% diagonal axis
for teller=2:a;
    for tel2=2:a;
        if tel2==teller;
            correlations(teller-1,tel2-1)=1;
        else
            if correlations(tel2-1, teller-1)==0
                [overlap(teller-1,tel2-1),correlations(teller-1,tel2-1)]...
                    =correlatie(seriesmatrix(teller,:),seriesmatrix(tel2,:),minoverlap);
                overlap(tel2-1,teller-1)=overlap(teller-1,tel2-1);
                correlations(tel2-1,teller-1)=correlations(teller-1,tel2-1);
            end
        end
    end
end