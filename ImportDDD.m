% This script is written to open a single or a group of ddd - files
% Files of this type will have the extension .DAT
% Author: Ronald Visser
Selection=menu('Do you want to import multiple or a single DDD-file?'...
    , 'Multiple (i.e. all) files from a directory'...
    , 'Convert a single file'...
    , 'Cancel');
if Selection==1 % import a whole directory of files
    [PathName]=uigetdir;
    Files=dir(PathName);
    [q p]=size(Files);
    for i=3:q;
        if Files(i).name(find(Files(i).name=='.')+1:end) == 'DDD' | Files(i).name(find(Files(i).name=='.')+1:end)=='ddd'
            DATFile=[PathName, '/', Files(i).name];
            DataFile=textread(DATFile,'%s');
            DataFile=DataFile(2:end);
            datering=str2double(DataFile{1});
            series=str2double(DataFile{2});
            replication=str2double(DataFile{4});
            pos=1;
            j=5;
            while j<=length(DataFile)-4
                switch(pos)
                    case 1
                        datering=[datering;str2double(DataFile{j})];
                        pos=2;
                        j=j+1;
                    case 2
                        series=[series;str2double(DataFile{j})];
                        pos=3;
                        j=j+1;
                    case 3         
                        pos=4;
                        j=j+1;          
                    case 4              
                        replication=[replication;str2double(DataFile{j})];
                        pos=1;
                        j=j+1;
                end
            end
            % van te voren invullen soort en locatie!!!!
            measurement(i).KeyCode=Files(i).name(1:find(Files(i).name=='.')-1);
            measurement(i).species='FREX';
            measurement(i).ringwidths=series;
            measurement(i).DateEnd=max(datering);
            measurement(i).Length=length(series);
            measurement(i).header='Valkenburg Es';
            measurement(i).sapwood=[];         
        end
    end
    measurement=measurement(3:end);
elseif Selection==2 % import a single file
    [FileName,PathName] = uigetfile('*.ddd','Select the ddd-file');
    DATFile=[PathName, FileName];
    DataFile=textread(DATFile,'%s');
    DataFile=DataFile(2:end);
    datering=str2double(DataFile{1});
    series=str2double(DataFile{2});
    replication=str2double(DataFile{4});
    pos=1;
    j=5;
    while j<=length(DataFile)-4
        switch(pos)
            case 1
                datering=[datering;str2double(DataFile{j})];
                pos=2;
                j=j+1;
            case 2
                series=[series;str2double(DataFile{j})];
                pos=3;
                j=j+1;
            case 3
                pos=4;
                j=j+1;
            case 4
                replication=[replication;str2double(DataFile{j})];
                pos=1;
                j=j+1;
        end
    end
    % van te voren invullen soort en locatie!!!!
    measurement.KeyCode=FileName(1:find(FileName=='.')-1);
    measurement.Species='FREX';
    measurement.ringwidths=series;
    measurement.DateEnd=max(datering);
    measurement.Length=length(series);
    measurement.header='Valkenburg Es';
    measurement.sapwood=[];
elseif Selection==3
end