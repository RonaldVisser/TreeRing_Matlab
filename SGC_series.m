% Calculate the number of similar growth changes and semi similar growth
% changes
function [n nSGC nSSGC SGC SSGC]=SGC_series(seriesA, seriesB, minoverlap)
L = ~isnan(seriesA) & ~isnan(seriesB);
n = sum(L); % overlap
if n > minoverlap
    % only compare parts that overlap
    seriesA=seriesA(L);
    seriesB=seriesB(L);    
    seriesA1=[seriesA(2:end) NaN];
    seriesB1=[seriesB(2:end) NaN];
    diffA_A1=seriesA-seriesA1;
    diffB_B1=seriesB-seriesB1;
    PosGC=(diffB_B1<0) + (diffA_A1<0);
    NegGC=(diffB_B1>0)+ (diffA_A1>0);
    NoGC=(diffB_B1==0)+(diffA_A1==0);
    SGC_log=(PosGC==2)+(NegGC==2)+(NoGC==2);
    SS_A_GC=(diffB_B1==0)+(diffA_A1~=0);
    SS_B_GC=(diffB_B1~=0)+(diffA_A1==0);
    SSGC_log=(SS_B_GC==2)+(SS_A_GC==2);
    nSGC=sum(SGC_log);
    nSSGC=sum(SSGC_log);
    SGC=100*(nSGC/(n-1));
    SSGC=100*(nSSGC/(n-1));
else
    SSGC=NaN;
    SGC=NaN;
    nSGC=NaN;
    nSSGC=NaN;
end