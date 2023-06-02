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
    [n_mtx corr_mtx]=corrmatrix(wuchsgroup(seriesmatrix),25); % correlatie of wuchs series
    [overlap_SGC nSGC_mtx nSSGC_mtx SGC_mtx SSGC_mtx] = SGC_matrix(seriesmatrix, 25); % SGC matrix
    glk_mtx=SGC_mtx + (SSGC_mtx/2); % gleichlaufichkeit
    p_mtx=pmatrix(glk_mtx, overlap_SGC); % probablility
    p_mtx2=p_mtx;
    p_mtx2(p_mtx > 0.01)=NaN; % keep all glk with probability > 0.01
    tv=~isnan(p_mtx2)+(SGC_mtx==100);
    %glk_mtx2=glk_mtx;
    SGC_mtx2=SGC_mtx;
    SGC_mtx2(tv==0)=NaN;
    SGC_mtx2(SGC_mtx2<50)=NaN; % remove all glk < 50 % (if any left)
    corr_mtx2=corr_mtx;
    corr_mtx2(corr_mtx2<0.4)=NaN; % remove all r < 0.4
    %corr_mtx2(corr_mtx2<=0)=NaN; % remove all r <= 0
    s=(SGC_mtx2/100).*corr_mtx2; % combine r and glk
    %s=(((SGC_mtx2*2)-100)/100).*corr_mtx2; % combine r and glk and correct for range
    maat=size(seriesmatrix);
    % convert correlation to distance
    distancesr=1-s;
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
    figure('units','pixels','Position',[100 100 900 700]);
    [H,T,perm] = dendrogram(clusterlistr,0, 'colorthreshold', 0.6, 'orientation','left', 'labels',label_n);
    set(H,'LineWidth',1);
    for permi=1:length(perm)
        ClustLabelOrder(permi,:)=label(perm(permi));
    end        
    x=2;
end