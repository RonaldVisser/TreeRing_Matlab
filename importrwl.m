function [label, seriesmatrix] = importrwl
% Script to open an rwl-file and import it to Matlab
% rwl-file has to have NO header!!!
tic;
% find the file to open
[FileName,PathName] = uigetfile('*.rwl','Select the rwlfile');
RWLFile=[PathName, FileName];
fid = fopen(RWLFile,'r');
% a cell-array is made with all data
[rings]=textscan(fid, '%8s');
rings=rings{:};
a=1;
c=1;
d=1;
% pre-allocate some space for matrices to save time
start_years=NaN(100000,1);
length_series=NaN(100000,1);
trw=NaN(length(rings),1);
label=cell(100000,1);
% proces starts here...
for i=1:length(rings);
    % determine if value is label (6 or more characters)
    if length(rings{i})>=5;
        % 1st value is always a label
        if a==1
            label(a)=rings(i);
            start_years(a)=str2num(rings{i+1});
            a=a+1;
        else
            % determine if label allready exists. If this is the case the
            % ringwidth values are added to the current series
            if strcmp(label(a-1), rings(i))
            else
                label(a)=rings(i);
                %disp(rings(i));
                length_series(a)=d;                
                start_years(a)=str2num(rings{i+1});
                a=a+1;
                d=1;
            end
        end;
    else
        % determine wether previous value is label, if so the current value
        % is the a startyear for the current line in the original rwl-file.
        % Startyears are written to special array
        if length(rings{i-1})>=5;
            %b=b+1;
        else
            % treeringwidth is written to array
            trw(c)=str2double(rings(i));
            c=c+1;
            d=d+1; % count number of rings
        end;
    end;
end;
length_series(a)=d; % add last length
length_series=length_series-2;
length_series=length_series(2:end);
%delete obsolete NaN's in trw and startyear
trw=trw(~isnan(trw));
start_years=start_years(~isnan(start_years));
length_series=length_series(~isnan(length_series));
% remove any obsolete labelfields
label=label(1:a-1);
fclose(fid);
toc
fprintf('%s\n', 'All series are read, they will now be placed in a single matrix')
tic;
% determine the last en first year of all series
mins=min(start_years);
maxs=max(start_years+length_series-1);
% preallocate matrix for all series
breedte=[length(mins:maxs)];
seriesmatrix=NaN(length(label)+1,breedte);
% fill first row with the years
seriesmatrix(1,:)=mins:maxs;
% all treeringwidth are placed in a matrix
trwpos=1;
for j=1:length(label)
    for q=1:length_series(j)
        if q==1
            position=find(seriesmatrix(1,:)==start_years(j));
            seriesmatrix(j+1,position)=trw(trwpos);
            position=position+1;
            trwpos=trwpos+1;           
        else
            if trw(trwpos)==999 && q == length_series(j) %trw(trwpos)
                trwpos=trwpos+1;
            else
                seriesmatrix(j+1,position)=trw(trwpos);
                trwpos=trwpos+1;
                position=position+1;
            end
        end
    end
    trwpos=trwpos+1;
end
% remove year 0
seriesmatrix(1,(seriesmatrix(1,:)<1))=seriesmatrix(1,(seriesmatrix(1,:)<1))-1;
toc
fprintf('%s %1.0f %s\n','There are', j, 'series placed in the matrix')
end