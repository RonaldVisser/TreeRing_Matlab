% calculating a simple moving avarage
function [moving_mtx]=movingavrg(seriesmatrix, nyrperiod)
[x y]=size(seriesmatrix);
moving_mtx=nan(x,y);
halfperiod=floor(nyrperiod/2);
moving_mtx(1,:)=seriesmatrix(1,:);
for i=2:x
   for j=1+halfperiod:y-halfperiod
       moving_mtx(i,j)=mean(seriesmatrix(i,j-halfperiod:j+halfperiod));
   end
end
