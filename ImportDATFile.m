% This script is written to open a single or a group of CATRAS (V1.0) - files
% Files of this type will have the extension .DAT
% Author: Ronald Visser
% called functions: binswitch
Selection=menu('Do you want to import multiple or a single CATRAS-file (V1.0)?'...
    , 'Multiple (i.e. all) files from a directory'...
    , 'Convert a single file'...
    , 'Cancel');
if Selection==1 % import a whole directory of files
    [PathName]=uigetdir;
    Files=dir(PathName);
    [q p]=size(Files);
    for i=3:q;
        if Files(i).name(8:11) == '.DAT' | Files(i).name(8:11)=='.dat'             
            DATFile=[PathName, '/', Files(i).name];
            fid = fopen(DATFile,'r');
            A = fread(fid);                       
            measurement(i-2).measurement=char(A(34:40)');
            measurement(i-2).header=char(A(1:33)');
            if A(42)==1
                measurement(i-2).Length=binswitch(A(41));
            elseif A(42)==0
                measurement(i-2).Length=A(41);
            end
            measurement(i-2).species='QUSP';
            measurement(i-2).sapwood=A(67);
            % position 44 is possibly a code for species;
            % postion 45-47 unknown;
            measurement(i-2).unknowntxt=char(A(49:53))';
            % position 54 - 58 unknown;
            measurement(i-2).date=char(A(59:65))';
            measurement(i-2).dated=char(A(69:75)');
            if A(82)==1
                start=binswitch(A(81));
            elseif A(82)==255
                start=A(81)-256;
            elseif A(82)==0
                start=0
                measurement(i-2).DateEnd=measurement.Length
            end
            if start < 0 & start+measurement(i-2).Length < 0
                measurement(i-2).DateEnd=start+measurement(i-2).Length-1;
            elseif start < 0 & start+measurement(i-2).Length > 0
                measurement(i-2).DateEnd=start+measurement(i-2).Length;
            elseif start > 0
                measurement(i-2).DateEnd=start+measurement(i-2).Length-1;
            end
            pos=1;
            for k=130:2:length(A)
                if A(k) == 1 && A(k-1) >= 0
                    measurement(i-2).ringwidths(pos)=A(k-1)+256;
                    pos=pos+1;
                elseif A(k)==0 && A(k-1) >= 0
                    measurement(i-2).ringwidths(pos)=A(k-1);
                    pos=pos+1;
                elseif A(k) == 2 && A(k-1) >= 0
                    measurement(i-2).ringwidths(pos)=A(k-1)+512;
                    pos=pos+1;
                elseif A(k) == 3 && A(k-1) >= 0
                    measurement(i-2).ringwidths(pos)=A(k-1)+768;
                    pos=pos+1;
                elseif A(k) == 4 && A(k-1) >= 0
                    measurement(i-2).ringwidths(pos)=A(k-1)+1024;
                    pos=pos+1;
                elseif A(k) == 5 && A(k-1) >= 0
                    measurement(i-2).ringwidths(pos)=A(k-1)+1280;
                    pos=pos+1;
                elseif A(k) == 6 && A(k-1) >= 0
                    measurement(i-2).ringwidths(pos)=A(k-1)+1536;
                    pos=pos+1;
                elseif A(k) == 7 && A(k-1) >= 0
                    measurement(i-2).ringwidths(pos)=A(k-1)+1792;
                    pos=pos+1;
                end
            end
            fclose(fid);
            clear A;
        end
    end
elseif Selection==2 % import a single file
    [FileName,PathName] = uigetfile('*.dat','Select the binaryfile');
    DATFile=[PathName, FileName];
    fid = fopen(DATFile,'r');
    A = fread(fid)
    measurement.measurement=char(A(34:40)');
    measurement.header=char(A(1:33)');
    if A(42)==1
        measurement.Length=binswitch(A(41));          
    elseif A(42)==0
        measurement.Length=A(41);
    end
    measurement.species='QUSP';
    measurement.sapwood=A(67);
    % position 44 is possibly a code for species;
    % postion 45-47 unknown;
    measurement.unknowntxt=char(A(49:53))';
    % position 54 - 58 unknown;
    measurement.date=char(A(59:65))';
    measurement.dated=char(A(69:75)');
    if A(82)==1
        start=binswitch(A(81));
    elseif A(82)==255
        start=A(81)-256;
    elseif A(82)==0
        start=0
        measurement.DateEnd=measurement.Length
    end
    if start < 0 & start+measurement.Length < 0
        measurement.DateEnd=start+measurement(i-2).Length-1;
    elseif start < 0 & start+measurement(i-2).Length > 0
        measurement.DateEnd=start+measurement(i-2).Length;
    elseif start > 0
        measurement.DateEnd=start+measurement(i-2).Length-1;
    end
    pos=1;
    for k=130:2:length(A)
        if A(k) == 1 && A(k-1) >= 0
            measurement.ringwidths(pos)=A(k-1)+256;
            pos=pos+1;
        elseif A(k)==0 && A(k-1) >= 0
            measurement.ringwidths(pos)=A(k-1);
            pos=pos+1;
        elseif A(k) == 2 && A(k-1) >= 0
            measurement.ringwidths(pos)=A(k-1)+512;
            pos=pos+1;
        elseif A(k) == 3 && A(k-1) >= 0
            measurement.ringwidths(pos)=A(k-1)+768;
            pos=pos+1;
        elseif A(k) == 4 && A(k-1) >= 0
            measurement.ringwidths(pos)=A(k-1)+1024;
            pos=pos+1;
        elseif A(k) == 5 && A(k-1) >= 0
            measurement.ringwidths(pos)=A(k-1)+1280;
            pos=pos+1;
        elseif A(k) == 6 && A(k-1) >= 0
            measurement.ringwidths(pos)=A(k-1)+1536;
            pos=pos+1;
        elseif A(k) == 7 && A(k-1) >= 0
            measurement.ringwidths(pos)=A(k-1)+1792;
            pos=pos+1;
        end
    end
    fclose(fid);
elseif Selection==3
end