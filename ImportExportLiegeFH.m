% Importing data from Liege

[FileName,PathName] = uigetfile('*.*','Select tree ring file');
tic;
LiegeFile=[PathName, FileName];
fid = fopen(LiegeFile,'r');
AllSeries=textscan(fid,'%s');
AllSeries=AllSeries{1};
i=1;
j=1;
while i<length(AllSeries)
    switch length(char(AllSeries(i)))
        case 1
            if char(AllSeries(i))=='.'
                i=i+1;
                measurement(j).Keycode=char(AllSeries(i));
                i=i+1;
            elseif char(AllSeries(i))==';'
                j=j+1;
                i=i+1;
            else
                i=i+1;
            end
        case 3
            switch char(AllSeries(i))
                case {'Lon','LON','lon'}
                    i=i+1;
                    measurement(j).Length=str2num(AllSeries{i});
                    i=i+1;
                case {'Esp','ESP','esp'}
                    i=i+1;
                    measurement(j).Species=AllSeries{i};
                    switch length(measurement(j).Species)
                        case 7          
                            if measurement(j).Species=='quercus'
                                measurement(j).Species='QUSP';
                            end
                        case 5
                            if measurement(j).Species=='CHENE'
                                measurement(j).Species='QUSP';
                            end
                    end
                    i=i+1;
                case {'ori','ORI','Ori'}
                    i=i+1;
                    measurement(j).startyear=str2num(AllSeries{i});
                    i=i+1;
                case {'ter','TER','Ter'}
                    i=i+1;
                    measurement(j).DateEnd=str2num(AllSeries{i});
                    i=i+1;
                case {'Aub','AUB','aub'}
                    i=i+1; 
                    measurement(j).Aub=str2num(AllSeries{i});
                    i=i+1;
                case {'Pos', 'POS', 'pos'}
                    i=i+1;
                    measurement(j).Pos=str2num(AllSeries{i});
                    i=i+1;                    
                otherwise
                    i=i+1;
            end
        case 7
            switch char(AllSeries(i))
                case {'Valeurs', 'valeurs', 'VALEURS'}
                    i=i+1;
                    for k=1:measurement(j).Length
                        treeringwidths(k)=str2num(AllSeries{i+k-1});
                    end
                    measurement(j).treeringwidths=treeringwidths;
                    clear treeringwidths;
                    i=i+k;
                otherwise
                    i=i+1;
            end
        otherwise
            i=i+1;
    end
end

% export to Heidelberg
[filename, pathname] = uiputfile({'*.fh', 'Heidelberg-format (*.fh)'; ...
    '*.*', 'All Files (*.*)'}, 'Enter a filename');
fid = fopen([pathname filename], 'wt');
[p q]=size(measurement);
for i=1:q
    fprintf(fid, '%s\n', 'HEADER:');
    fprintf(fid, '%s%s\n', 'Keycode=', measurement(i).Keycode);
    fprintf(fid, '%s%d\n', 'Length=', measurement(i).Length);
    fprintf(fid, '%s%d\n', 'DateEnd=', measurement(i).DateEnd);
    fprintf(fid, '%s%s\n', 'Species=', measurement(i).Species);
%    fprintf(fid, '%s%s\n', 'Location=', measurement(i).header);
%    fprintf(fid, '%s%1.0f\n', 'SapWoodRings=', measurement(i).Sapwood);
    fprintf(fid, '%s\n', 'DATA:Tree');
    l=length(measurement(i).treeringwidths);
    measurement(i).treeringwidths(l+1:(ceil(l/10))*10)=0;
    for j=1:length(measurement(i).treeringwidths)/10
        fprintf(fid, '   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f\n', ...
            measurement(i).treeringwidths((j*10)-9:(j*10)));
    end
end
fclose(fid);
clear all
clc