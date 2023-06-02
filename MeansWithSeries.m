% Vergelijking mean met alles
% Series plaatsenstand128
clear all;
%[label, seriesmatrix] = importrwl;
run ImportFH;
maatseries=size(seriesmatrix);
AllDated=seriesmatrix;
AllDatedStruct=measurement;
AllDatedLabel=label;
clear seriesmatrix measurement label;
% Ask to open means or use same series
answer = questdlg('Would you like to compare these series to themselves or do you have a file with means?', ...
	'Same or different', ...
	'Use same series','Import other series/means','Use same series');
% Handle response
switch answer
    case 'Use same series'
        Means=AllDated;
        MeansStruct=AllDatedStruct;
        MeansLabel=AllDatedLabel;
    case 'Import other series/means'
        run ImportFH;
        %[label, seriesmatrix] = importrwl;
        Means=seriesmatrix;
        MeansStruct=measurement;
        MeansLabel=label;
        clear seriesmatrix measurement label;
end
maat=size(Means);
Passend(1,:)={'Mean' 'Dendro' 'overlap' 'r' 'r(wuchs)' 't' 't(wuchs)' 'SGC' 'SSGC' 'p' 'p_glk' 'Overlap_start' 'Overlap_end'};
% pre allocate space for comparisons
Passend(2:(maat(1)*maatseries(1))+1,:)=cell(maat(1)*maatseries(1),13);
% locatie voor bestanden kiezen
[filename, pathname] = uiputfile({'*.*', 'All Files (*.*)'}, 'Choose Folder and Filenaam for csv(no extension)');
q=2;
for i=2:maat(1)
    %MeanEnd=MeansStruct(i-1).DateEnd;
    MeanEnd=max(Means(1,(~isnan(Means(i,:)))));
    fprintf('%s%s%1.0f%s%1.0f%s\n', MeansLabel{i-1}, '( is MeanSeries ', i-1, ' of ', maat(1)-1, ' )');
    %MeanStart=MeansStruct(i-1).DateEnd-MeansStruct(i-1).Length+1;
    MeanStart=min(Means(1,(~isnan(Means(i,:)))));
    %if MeanEnd > 0 && MeanStart < 0
    %    MeanStart=MeanStart-1; % let op -1, want 1 jaar verder terug in tijd, wat 0 weg!
    %end
    % shorten mean if series start later
    if MeanStart < AllDated(1,1)
        MeanStart=AllDated(1,1);
    end
    % shorten mean if series end earlier
    if MeanEnd > AllDated(1,end)
        MeanEnd = AllDated(1,end);
    end
    MeanEndPos=find(Means(1,:)==MeanEnd);
    MeanStartPos=find(Means(1,:)==MeanStart);
    StartComp=find(AllDated(1,:)==MeanStart);
    EndComp=find(AllDated(1,:)==MeanEnd);
    for j=2:maatseries(1)
        %fprintf('%s%s%s\n',MeansLabel{i-1}, ' & ', AllDatedLabel{j-1});
        comparing=[Means(1,MeanStartPos:MeanEndPos);Means(i,MeanStartPos:MeanEndPos);AllDated(j,StartComp:EndComp)];
        %[nglk glk]=gleichlaufich(comparing(2,:),comparing(3,:),25);
        [n nSGC nSSGC SGC SSGC]=SGC_series(comparing(2,:), comparing(3,:), 25);
        if ~isnan(nSGC) && SGC > 50
            [nr r]=correlatie(comparing(2,:),comparing(3,:),20);
            [nwr wr]=correlatie(wuchswerte(comparing(2,:)),wuchswerte(comparing(3,:)),25);
            [nt t]=tvalue(comparing(2,:),comparing(3,:),25);
            [nwt wt]=tvalue(wuchswerte(comparing(2,:)),wuchswerte(comparing(3,:)),25);
            s=1/(2*sqrt(nSGC));
            z=((SGC/100)-0.495)/s;
            z_glk=(((SGC+(SSGC/2))/100)-0.5)/s;
            p_glk=2*(1-normcdf(z_glk,0,1));
            p=2*(1-normcdf(z,0,1));
            StartOverlap = max(min(Means(1,~isnan(Means(i,:)))),min(AllDated(1,~isnan(AllDated(j,:)))));
            EndOverlap = min(max(Means(1,~isnan(Means(i,:)))),max(AllDated(1,~isnan(AllDated(j,:)))));
            Passend(q,:)=[MeansLabel(i-1) AllDatedLabel(j-1) nr r wr t wt SGC SSGC p p_glk StartOverlap EndOverlap ];
            q=q+1;
            clear nr r nwr wr nt t s z z_glk p_glk p n nSGC nSSGC SGC SSGC StartOverlap EndOverlap;
        end
        clear comparing
    end
end
% remove exta allocated space in Passend
Passend=Passend(1:q,:);
% maximale waardes
% maxSSGC = max(cell2mat(Passend(2:end,9))) % max SSGC
% minSSGC = min(cell2mat(Passend(2:end,9))) % max SSGC
% meanSSGC = mean(cell2mat(Passend(2:end,9))) % max SSGC
% stdevSSGC = std(cell2mat(Passend(2:end,9))) % max SSGC
% maxSGC = max(cell2mat(Passend(2:end,8))) % max SSGC

% Alles plaatsen in csv file
[x y] = size(Passend);
MeanAllSeries=[filename '.csv'];
fid = fopen([pathname MeanAllSeries], 'wt');
fprintf(fid, '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n', Passend{1,1}, ';Radius_A;', Passend{1,2}, ';Radius_B;', Passend{1,3}, ';', Passend{1,4}, ';', Passend{1,5}, ';', Passend{1,6}, ';', Passend{1,7}, ';', Passend{1,8}, ';', Passend{1,9}, ';', Passend{1,10}, ';', Passend{1,11},';', Passend{1,12},';', Passend{1,13});
for i=2:x-1
    fprintf(fid, '%s%s%s%s%s%s%s%s%1.0f%s%6.5f%s%6.5f%s%6.5f%s%6.5f%s%6.4f%s%6.4f%s%9.8f%s%9.8f%s%1.0f%s%1.0f\n', Passend{i,1}(1:end-1), ';', Passend{i,1}(end), ';', Passend{i,2}(1:end-1), ';', Passend{i,2}(end), ';', Passend{i,3}, ';', Passend{i,4}, ';', Passend{i,5}, ';', Passend{i,6}, ';', Passend{i,7}, ';', Passend{i,8}, ';', Passend{i,9}, ';', Passend{i,10}, ';', Passend{i,11},';', Passend{i,12},';', Passend{i,13});
    %fprintf(fid, '%s%s%s%s%s%s%s%s%1.0f%s%6.5f%s%6.5f%s%6.5f%s%6.5f%s%6.4f%s%6.4f%s%9.8f%s%9.8f\n', Passend{i,1}(1:end-1), ';', Passend{i,1}(end), ';', Passend{i,2}(1:end), ';', 'R', ';', Passend{i,3}, ';', Passend{i,4}, ';', Passend{i,5}, ';', Passend{i,6}, ';', Passend{i,7}, ';', Passend{i,8}, ';', Passend{i,9}, ';', Passend{i,10}, ';', Passend{i,11});
    %fprintf(fid, '%s%s%s%s%s%s%s%s%1.0f%s%6.5f%s%6.5f%s%6.5f%s%6.5f%s%6.4f%s%6.4f%s%9.8f%s%9.8f\n', Passend{i,1}(1:end), ';', 'R', ';', Passend{i,2}(1:end), ';', 'R', ';', Passend{i,3}, ';', Passend{i,4}, ';', Passend{i,5}, ';', Passend{i,6}, ';', Passend{i,7}, ';', Passend{i,8}, ';', Passend{i,9}, ';', Passend{i,10}, ';', Passend{i,11});
end
fclose(fid);
clear i x y Statistiek;