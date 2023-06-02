function mean0var1_mtx=mean0var1(seriesmatrix);
[x,y]=size(seriesmatrix);
mean0var1_mtx=nan(x,y);
mean0var1_mtx(1,:)=seriesmatrix(1,:);
for i=2:x
    meani=nanmean(seriesmatrix(i,:));
    stdi=nanstd(seriesmatrix(i,:));
    mean0var1_mtx(i,:)=((seriesmatrix(i,:))-meani)/stdi;    
end
