% correlation-matrix of columnwise treering file imported with YuxMatlab.m
% or with importrwl. A minimum overlap op 50 years is used
function [overlap, tvalues] = Tmatrix(columntreerings, minoverlap)
tic;
[a,b]=size(columntreerings);
% pre-allocate overlap and tvalues
tvalues=zeros(a-1,a-1);
overlap=zeros(a-1,a-1);
% start calculating all tvalues and mirror all tvalues along
% diagonal axis
for teller=2:a;
    for tel2=2:a;
        if tel2==teller;
            tvalues(teller-1,tel2-1)=100;
        else
            if tvalues(tel2-1, teller-1)==0
                [overlap(teller-1,tel2-1),tvalues(teller-1,tel2-1)]...
                    =tvalue(columntreerings(teller,:), columntreerings(tel2,:), minoverlap);
                overlap(tel2-1,teller-1)=overlap(teller-1,tel2-1);
                tvalues(tel2-1,teller-1)=tvalues(teller-1,tel2-1);
            end
        end
    end
end
toc;