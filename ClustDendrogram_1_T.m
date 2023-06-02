% dendrogram op basis corrmatrix
close all;
clear all;
x=1;
while x==1
    Selection=menu('What kind of import file do you have?'...
        , 'Heidelberg (FH)'...
        , 'Tucson (rwl)'...
        , 'Cancel');
    if Selection==1 % fh-file
        run ImportFH;
    elseif Selection==2
        [label, seriesmatrix] = importrwl;
    elseif Selection==3
        x=2;
    end
    %[n_mtx T_mtx]=Tmatrix((wuchsgroup(seriesmatrix)),50); % Students t of wuchs series
    [n_mtx T_mtx]=Tmatrix(seriesmatrix,50); % Students t of wuchs series
    T_mtx(T_mtx<0)=NaN; % negatieve T verwijderen
    maat=size(seriesmatrix);
    % convert correlation to distance
    distancesr=1./T_mtx;
    % make diagonal 0
    distancesr(logical(eye(size(distancesr))))=0;
    pr=squareform(distancesr);
    clusterlistr=linkage(pr);
    if Selection==1
        for i=1:maat(1)-1
            label_n(i,:)={[measurement(i).KeyCode [' (n='] num2str(measurement(i).Length) [') Date: '] num2str(measurement(i).DateEnd-measurement(i).Length+1) [' -> '] num2str(measurement(i).DateEnd)]};
        end
    elseif Selection==2
        for i=1:maat(1)-1
            DateMax=max(seriesmatrix(1,(~isnan(seriesmatrix(i+1,:)))));
            DateMin=min(seriesmatrix(1,(~isnan(seriesmatrix(i+1,:)))));
            Length=sum(~isnan(seriesmatrix(i+1,:)));
            label_n(i,:)=strcat(label(i), ' (n=', num2str(Length), ') Datering:', num2str(DateMin), ' -> ', num2str(DateMax));
        end
    end
    figure('units','pixels','Position',[100 100 800 600]);
    [H,T,perm] = dendrogram(clusterlistr, 0, 'colorthreshold', 0.6, 'orientation','left', 'labels',label_n);
    set(H,'LineWidth',1);
    for permi=1:length(perm)
        ClustLabelOrder(permi,:)=label(perm(permi));
    end        
    x=2;
end