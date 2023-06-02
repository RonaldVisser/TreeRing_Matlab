%function PointerInterval_mtx=PointerInterval(seriesmatrix)
% PointerInterval as proposed by Schweingruber et al 1990, 21)
maat = size(seriesmatrix);
GC_mtx=zeros(maat);
GC_mtx(1,:)=seriesmatrix(1,:);
for i=2:maat(1)
    seriesA=seriesmatrix(i,:);
    seriesA1=[seriesA(2:end) NaN];
    GC_mtx(i,:)=seriesA1-seriesA;
end
% relocate date headers and restructure matrix to correct dates
GC_mtx=[nan(maat(1),1) GC_mtx];
GC_mtx(1,1:end-1)=GC_mtx(1,2:end);
GC_mtx=GC_mtx(:,1:end-1);
% calculate overlap
overlap=sum(~isnan(seriesmatrix(2:end,:)));
overlap_GC=sum(~isnan(GC_mtx(2:end,:)));
limit999=0.5+(0.5./overlap_GC)+(3.30*sqrt(0.25./overlap_GC));
limit99=0.5+(0.5./overlap_GC)+(2.58*sqrt(0.25./overlap_GC));
limit95=0.5+(0.5./overlap_GC)+(1.96*sqrt(0.25./overlap_GC));
limit90=0.5+(0.5./overlap_GC)+(1.65*sqrt(0.25./overlap_GC));
PointerInterval_mtx=zeros(13,maat(2));
PointerInterval_mtx(1,:)=seriesmatrix(1,:);
%PointerInterval_mtx(2,:)=overlap; % aantal series in jaar; niet aantal pointermogelijkheden!
PointerInterval_mtx(2,:)=overlap_GC; % aantal groeiveranderingen in jaar!
NegGrowth=GC_mtx(2:end,:)<0;
PosGrowth=GC_mtx(2:end,:)>0;
EqualGrowth=GC_mtx(2:end,:)==0;
PointerInterval_mtx(3,:)=sum(NegGrowth); % negative growth
PointerInterval_mtx(4,:)=PointerInterval_mtx(3,:)./overlap_GC; % percentage negative
PointerInterval_mtx(5,:)=sum(PosGrowth); % positive growth
PointerInterval_mtx(6,:)=PointerInterval_mtx(5,:)./overlap_GC; % percentage positive
PointerInterval_mtx(7,:)=sum(EqualGrowth); % equal growth
PointerInterval_mtx(8,:)=PointerInterval_mtx(7,:)./overlap_GC; % percentage positive
%.....
Pointers=zeros(1,maat(2));
PointerNeg999=(PointerInterval_mtx(4,:)>=limit999);
PointerNeg99=(PointerInterval_mtx(4,:)>=limit99);
PointerNeg95=(PointerInterval_mtx(4,:)>=limit95);
PointerNeg90=(PointerInterval_mtx(4,:)>=limit90);
Pointers(PointerNeg90)=-90;
Pointers(PointerNeg95)=-95;
Pointers(PointerNeg99)=-99;
Pointers(PointerNeg999)=-99.9;
PointerPos999=(PointerInterval_mtx(6,:)>=limit999);
PointerPos99=(PointerInterval_mtx(6,:)>=limit99);
PointerPos95=(PointerInterval_mtx(6,:)>=limit95);
PointerPos90=(PointerInterval_mtx(6,:)>=limit90);
Pointers(PointerPos90)=90;
Pointers(PointerPos95)=95;
Pointers(PointerPos99)=99;
Pointers(PointerPos999)=99.9;
PointerInterval_mtx(9,:)=Pointers; % pointer years with certainty

% determine number of pointer years for series
PointerSeries=nan(maat);
PointerSeries(1,:)=seriesmatrix(1,:);
for i=2:maat(1)
    PointerSeries(i,NegGrowth(i-1,(PointerInterval_mtx(9,:)<0)))=-1;
    %PointerSeries(i,NegGrowth(i-1,((PointerInterval_mtx(3,:)>4)+(overlap>4))==2))=-1;
    PointerSeries(i,PosGrowth(i-1,(PointerInterval_mtx(9,:)>0)))=1;
    %PointerSeries(i,PosGrowth(i-1,((PointerInterval_mtx(5,:)>4)+(overlap>4))==2))=1;
    PointerSeries(i,EqualGrowth(i-1,(PointerInterval_mtx(9,:)==0)))=0;
    %PointerSeries(i,EqualGrowth(i-1,((PointerInterval_mtx(7,:)>4)+(overlap>4))==2))=0;
end
length_series=sum(~isnan(seriesmatrix(2:end,:)),2);
overlap_series_over_four=sum(~isnan(seriesmatrix(2:end,overlap_GC>4)),2);
number_pointers=sum(~isnan(PointerSeries(2:end,:)),2);
%pointers_vs_length=number_pointers./length_series;
pointers_vs_ol_over_4=number_pointers./overlap_series_over_four;
% bar graph with negative pointers and positive pointers in aantallen
% 99 % zekerheid
PointerInterval_mtx(10,(PointerInterval_mtx(9,:)==-99.9))=(PointerInterval_mtx(3,(PointerInterval_mtx(9,:)==-99.9))*-1);
PointerInterval_mtx(10,(PointerInterval_mtx(9,:)==99.9))=(PointerInterval_mtx(5,(PointerInterval_mtx(9,:)==99.9)));
% 99 % zekerheid
PointerInterval_mtx(11,(PointerInterval_mtx(9,:)==-99))=(PointerInterval_mtx(3,(PointerInterval_mtx(9,:)==-99))*-1);
PointerInterval_mtx(11,(PointerInterval_mtx(9,:)==99))=(PointerInterval_mtx(5,(PointerInterval_mtx(9,:)==99)));
% 95 % zekerheid
PointerInterval_mtx(12,(PointerInterval_mtx(9,:)==-95))=(PointerInterval_mtx(3,(PointerInterval_mtx(9,:)==-95))*-1);
PointerInterval_mtx(12,(PointerInterval_mtx(9,:)==95))=(PointerInterval_mtx(5,(PointerInterval_mtx(9,:)==95)));
% 90 % zekerheid
PointerInterval_mtx(13,(PointerInterval_mtx(9,:)==-90))=(PointerInterval_mtx(3,(PointerInterval_mtx(9,:)==-90))*-1);
PointerInterval_mtx(13,(PointerInterval_mtx(9,:)==90))=(PointerInterval_mtx(5,(PointerInterval_mtx(9,:)==90)));

% aantal pointers in periodes met minder dan 5 reeksen en meer dan 1
NegPointers2to4series=sum((PointerInterval_mtx(4,((PointerInterval_mtx(2,:)>1)+(PointerInterval_mtx(2,:)<5)==2)))==1);
PosPointers2to4series=sum((PointerInterval_mtx(6,((PointerInterval_mtx(2,:)>1)+(PointerInterval_mtx(2,:)<5)==2)))==1);
EqualPointers2to4series=sum((PointerInterval_mtx(8,((PointerInterval_mtx(2,:)>1)+(PointerInterval_mtx(2,:)<5)==2)))==1);

% overzicht aantalen (pos - neg met per regel minder zekerheid)
Totalen = [sum(PointerNeg999) sum(PointerPos999); sum(PointerNeg99) sum(PointerPos99); ...
    sum(PointerNeg95) sum(PointerPos95); sum(PointerNeg90) sum(PointerPos90)];

%fprintf('%s%3.2f%s%s\n', 'Less pointers: ', min(pointers_vs_length)*100, '%, series: ', label{find(pointers_vs_length==(min(pointers_vs_length)))});
fprintf('%s%1.0f%s%1.0f%s%3.2f%s\n','Totaal aantal pointers: ', sum(Totalen(4,:)), ' gedurende een periode van ', sum(PointerInterval_mtx(2,:)>4), ' jaar (', ((sum(Totalen(4,:)))/(sum(PointerInterval_mtx(2,:)>4)))*100, '%).')
fprintf('%s%3.2f%s%s\n', 'Less significant pointers: ', min(pointers_vs_ol_over_4)*100, '%, series: ', label{find(pointers_vs_ol_over_4==(min(pointers_vs_ol_over_4)))});
fprintf('%s%1.0f\n', 'Number of years with only 1 series: ', sum(PointerInterval_mtx(2,:)==1));
fprintf('%s%1.0f\n', 'Nr of years with 2-4 series where all series show synchronous growth: ', NegPointers2to4series+PosPointers2to4series+EqualPointers2to4series);

figure('units','pixels','Position',[0 100 1200 600]);
hold all
MeanSeries=MeanCurve(mean0var1(seriesmatrix));
line(MeanSeries(1,:),MeanSeries(2,:)*20,'Color','r')
bar(PointerInterval_mtx(1,:),PointerInterval_mtx(11,:),'r')
bar(PointerInterval_mtx(1,:),PointerInterval_mtx(11,:),'y')
bar(PointerInterval_mtx(1,:),PointerInterval_mtx(12,:),'g')
bar(PointerInterval_mtx(1,:),PointerInterval_mtx(13,:),'b')
line(PointerInterval_mtx(1,:),PointerInterval_mtx(2,:))
line(PointerInterval_mtx(1,:),PointerInterval_mtx(2,:)*-1)
title({'Totaal aantal pointers: ' sum(Totalen(4,:)) ' gedurende een periode van ' sum(PointerInterval_mtx(2,:)>4) ' jaar (' ((sum(Totalen(4,:)))/(sum(PointerInterval_mtx(2,:)>4)))*100 '%).'})

MeanSeries=MeanCurve(seriesmatrix);
