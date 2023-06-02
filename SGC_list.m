% correlation-matrix of columnwise treering file imported with YuxMatlab.m
% or with importrwl
function [overlap_list nSGC_list nSSGC_list SGC_list SSGC_list p_SGC_list] = SGC_list(seriesmatrix, minoverlap)
tic;
[a,b]=size(seriesmatrix);
% pre-allocate overlap, SSGC and SGC
nSGC_list=nan((a*a),1);
SGC_list=nan((a*a),1);
nSSGC_list=nan((a*a),1);
SSGC_list=nan((a*a),1);
overlap_list=nan((a*a),1);
p_SGC_list=nan((a*a),1);
q=1;
for teller=2:a;
    fprintf('%1.0f%s%1.0f\n',teller-1, ' of ', a-1);
    for tel2=2:a;
        if tel2==teller;
            SGC_list(q,1)=100;
            SSGC_list(q,1)=0;
            q=q+1;
        elseif teller<tel2
            [overlap_list(q) nSGC_list(q) nSSGC_list(q) SGC_list(q) SSGC_list(q)]=SGC_series(seriesmatrix(teller,:), seriesmatrix(tel2,:), minoverlap);
            s=1/(2*sqrt(overlap_list(q)));
            z=((SGC_list(q)/100)-0.495)/s;
            p_SGC_list(q)=2*(1-normcdf(z,0,1));
            if SSGC_list(q)>30
                fprintf('%1.0f%s%1.0f%s%1.0f%s%1.0f\n', teller-1, ' and ', tel2-1, ' with ' , SSGC_list(q), ' and ' , SGC_list(q));
            end
            q=q+1;
        end
    end
end
overlap_list=overlap_list(~isnan(SGC_list));
nSGC_list=nSGC_list(~isnan(SGC_list));
nSSGC_list=nSSGC_list(~isnan(SGC_list));
SSGC_list=SSGC_list(~isnan(SGC_list));
SGC_list=SGC_list(~isnan(SGC_list));
p_SGC_list=p_SGC_list(~isnan(SGC_list));
fprintf('%1.0f%s\n', q, ' comparisons');
toc;