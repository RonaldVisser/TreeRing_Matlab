% BAI voor matrix
function BAI_Matrix=BAIMatrix(seriesmatrix)
[x y]=size(seriesmatrix);
BAI_Matrix=zeros(x, y);
BAI_Matrix(BAI_Matrix==0)=NaN;
BAI_Matrix(1,:)=seriesmatrix(1,:);
for i=2:x
    Locations=~isnan(seriesmatrix(i,:));
    BAI_Values=BAI(seriesmatrix(i,Locations));
    BAI_Matrix(i,Locations)=BAI_Values;
    clear BAI_Values Locations;
end
clear x y;