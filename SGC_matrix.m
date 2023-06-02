% correlation-matrix of columnwise treering file imported with YuxMatlab.m
% or with importrwl
function [overlap nSGC_mtx nSSGC_mtx SGC_mtx SSGC_mtx] = SGC_matrix(seriesmatrix, minoverlap)
tic;
[a,b]=size(seriesmatrix);
% pre-allocate overlap and SGC
nSGC_mtx=zeros(a-1,a-1);
SGC_mtx=zeros(a-1,a-1);
nSSGC_mtx=zeros(a-1,a-1);
SSGC_mtx=zeros(a-1,a-1);
overlap=zeros(a-1,a-1);
% start calculating all gleichlaufichkeiten and mirror all gleichlaufichkeiten along
% diagonal axis
for teller=2:a;
    for tel2=2:a;
        if tel2==teller;
            SGC_mtx(teller-1,tel2-1)=100;
            SSGC_mtx(teller-1,tel2-1)=0;
        else
            if SGC_mtx(teller-1, tel2-1)==0
                [overlap(teller-1,tel2-1), nSGC_mtx(teller-1,tel2-1), nSSGC_mtx(teller-1,tel2-1), SGC_mtx(teller-1,tel2-1), SSGC_mtx(teller-1,tel2-1)]=SGC_series(seriesmatrix(teller,:), seriesmatrix(tel2,:), minoverlap);
                overlap(tel2-1,teller-1)=overlap(teller-1,tel2-1);
                SGC_mtx(tel2-1,teller-1)=SGC_mtx(teller-1,tel2-1);
                SSGC_mtx(tel2-1,teller-1)=SSGC_mtx(teller-1,tel2-1);
            end
        end
    end
end
toc;