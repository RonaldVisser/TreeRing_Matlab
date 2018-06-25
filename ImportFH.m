% Script to import heidelberg(fh) in MATLAB
[FileName,PathName] = uigetfile('*.fh','Select tree ring file (Heidelberg-format');
tic;
FHFile=[PathName,FileName];
fid = fopen(FHFile,'r','ieee-le', 'UTF-8');
i=1;
X=0;
while X~=999
    A=textscan(fid,'%s', 1,'delimiter', '\n');
    switch length(char(A{1}))
        case 9
            if char(A{1})=='DATA:Tree'
                measurement(i).Length=str2num(measurement(i).Length);
                measurement(i).DateEnd=str2num(measurement(i).DateEnd);
                %measurement.SapWoodRings=str2num(measurement.SapWoodRings)
                measurement(i).treeringwidths=textscan(fid,'%d',measurement(i).Length);
                if 10*ceil(measurement(i).Length/10)>measurement(i).Length
                    textscan(fid,'%d',10*ceil(measurement(i).Length/10)-measurement(i).Length);
                end
                i=i+1;
                A=textscan(fid,'%s', 1,'delimiter', '\n');
            else
                B=char(A{1});
                C=find(B=='=');
                measurement(i).(B(1:C-1))=B(C+1:end);
            end
        case 7
            if char(A{1}) == 'HEADER:'
                A=textscan(fid,'%s',1,'delimiter', '\n');             
                B=char(A{1});
                C=find(B=='=');
                measurement(i).(B(1:C-1))=B(C+1:end);
            end
        case 11
            if char(A{1}) == 'DATA:Chrono'
                measurement(i).Length=str2num(measurement(i).Length);
                measurement(i).DateEnd=str2num(measurement(i).DateEnd);
                if measurement(i).Length*4>floor(measurement(i).Length*4)
                    k=ceil(measurement(i).Length*4);
                else
                    k=measurement(i).Length*4;
                end
                tempwidths=textscan(fid,'%d', k);
                tempwidths=tempwidths{1,1};
                q=1;
                q2=1;
                for j=1:k
                    if j==q2
                        measurement(i).treeringwidths(q)=tempwidths(q2);
                        q=q+1;
                        q2=q2+4;
                    end
                end
                measurement(i).treeringwidths={measurement(i).treeringwidths};
                measurement(1).treeringwidths{1}=measurement(1).treeringwidths{1}';
                i=i+1;
                A=textscan(fid,'%s', 1,'delimiter', '\n');
            else
                B=char(A{1});
                C=find(B=='=');
                measurement(i).(B(1:C-1))=B(C+1:end);
            end
        case 0
            X=999;
        otherwise
            B=char(A{1});
            C=find(B=='=');
            measurement(i).(B(1:C-1))=B(C+1:end);            
    end
end

%if isfield(measurement, 'Keycode')
%    for i=1:length(measurement)
%        measurement(i).KeyCode=measurement(i).Keycode;
%    end
%    measurement=rmfield(measurement, 'Keycode');
%end
i=length(measurement);
fprintf('%s %1.0f %s\n','Congratulations, you have successfully imported',i, 'measurements.')
toc

tic;
% placing in matrix
earliest=min([measurement(1:end).DateEnd]-[measurement(1:end).Length]+1);
latest=max([measurement(1:end).DateEnd]);
if earliest <= 0 && latest > 0
    earliest = earliest-1;
end
years=linspace(earliest,latest,(latest-earliest+1));
years(find(years==0))=[];
seriesmatrix=NaN(i+1,length(years));
label=cell(i,1);
% fill first row with the years
seriesmatrix(1,:)=years;
for j = 2:i+1
    SeriesDate=measurement(j-1).DateEnd;
    position=find(SeriesDate==seriesmatrix(1,:));
    seriesmatrix(j,(position-measurement(j-1).Length+1):position)=measurement(j-1).treeringwidths{1};
    label{j-1}=measurement(j-1).KeyCode;
end
% label(j)=[];
fprintf('%s\n','All series are placed in the matrix')
toc
clear A B C FHFile FileName PathName SeriesDate X earliest fid i j latest position years;