function ImportExportDATFH

% Import CATRAS(V1.0) and export to Heidelberg(*.FH)
% This script is written to open a single or a group of CATRAS (V1.0) - files
% Files of this type will have the extension .DAT
% Author: Ronald Visser
% called functions: binswitch

% This script is written to open a single or a group of CATRAS (V1.0) - files
% Files of this type will have the extension .DAT
% Author: Ronald Visser
% called functions: binswitch
Selection=menu('Do you want to import multiple or a single CATRAS-file (V1.0)?'...
    , 'Multiple (i.e. all) files from a directory (linux)'...
    , 'Multiple (i.e. all) files from a directory (M$-Windows)'...
    , 'Convert a single file'...
    , 'Cancel');
if Selection==1 % import a whole directory of files under linux
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
                start=binswitch(C(81));
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
            for k=129:length(A)
                if A(k) == 1 & A(k-1) > 0
                    measurement(i-2).ringwidths(pos)=binswitch(A(k-1));
                    pos=pos+1;
                elseif A(k)==0 & A(k-1) > 1
                    measurement(i-2).ringwidths(pos)=A(k-1);
                    pos=pos+1;
                end
            end
            fclose(fid);
        end
    end
elseif Selection==2 % import a whole directory of files under windows
    [PathName]=uigetdir;
    Files=ls(PathName);
    [q p]=size(Files);
    for i=3:q;
        if Files(i,8:11) == '.DAT' | Files(i,8:11)=='.dat' 
            DATFile=[PathName, '\', Files(i,:)];
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
                start=binswitch(C(81));
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
            for k=129:length(A)
                if A(k) == 1 & A(k-1) > 0
                    measurement(i-2).ringwidths(pos)=binswitch(A(k-1));
                    pos=pos+1;
                elseif A(k)==0 & A(k-1) > 1
                    measurement(i-2).ringwidths(pos)=A(k-1);
                    pos=pos+1;
                end
            end
            fclose(fid);
        end
    end
elseif Selection==3 % import a single file
    [FileName,PathName] = uigetfile('*.dat','Select the binaryfile');
    DATFile=[PathName, FileName];
    fid = fopen(DATFile,'r');
    A = fread(fid);
    measurement.measurement=char(A(34:40)');
    measurement.header=char(A(1:33)');
    if A(42)==1
        measurement.Length=binswitch(A(41));
    elseif A(42)==0
        measurement.Length=A(41);
    end
    % position 42-43 is unknown;
    % position 44 is possibly a code for species;
    measurement.species='QUSP';
    % postion 45-47 unknown;
    measurement.unknowntxt=char(A(49:58))';
    measurement.measuredate=char(A(59:65))';
    measurement.sapwood=A(67);
    measurement.dated=char(A(69:75)');
    if A(82)==1
        start=binswitch(C(81));
    elseif A(82)==255
        start=A(81)-256;
    elseif A(82)==0
        start=0
        measurement(i-2).DateEnd=measurement.Length
    end
    if start < 0 & start+measurement.Length < 0
        measurement.DateEnd=start+measurement.Length-1;
    elseif start < 0 & start+measurement.Length > 0
        measurement.DateEnd=start+measurement.Length;
    elseif start > 0
        measurement.DateEnd=start+measurement.Length-1;
    end
    pos=1;
    for k=129:length(A)
        if A(k) == 1 & A(k-1) > 0
            measurement.ringwidths(pos)=binswitch(A(k-1));
            pos=pos+1;
        elseif A(k)==0 & A(k-1) > 1
            measurement.ringwidths(pos)=A(k-1);
            pos=pos+1;
        end
    end
    fclose(fid);
    fid = fopen(DATFile,'r');
    C = fread(fid, 128, 'schar');
    if C(82)==1
        start=binswitch(C(81))
    elseif C(82)==-1
        start=A(81)-256
    end
    if start < 0 & start+measurement.Length < 0
        measurement.DateEnd=start+measurement.Length-1;
    elseif start < 0 & start+measurement.Length > 0
        measurement.DateEnd=start+measurement.Length;
    elseif start > 0
        measurement.DateEnd=start+measurement.Length-1;
    end
    fclose(fid);
elseif Selection==4
end

% export to Heidelberg
[filename, pathname] = uiputfile({'*.fh', 'Heidelberg-format (*.fh)'; ...
    '*.*', 'All Files (*.*)'}, 'Enter a filename');
fid = fopen([pathname filename], 'wt');
[p q]=size(measurement);
for i=1:q
    fprintf(fid, '%s\n', 'HEADER:');
    fprintf(fid, '%s%s\n', 'Keycode=', measurement(i).measurement);
    fprintf(fid, '%s%1.0f\n', 'Length=', length(measurement(i).ringwidths(measurement(i).ringwidths~=0)));
    fprintf(fid, '%s%1.0f\n', 'DateEnd=', measurement(i).DateEnd);
    fprintf(fid, '%s%s\n', 'Species=', measurement(i).species);
    fprintf(fid, '%s%s\n', 'Location=', measurement(i).header);
    fprintf(fid, '%s%1.0f\n', 'SapWoodRings=', measurement(i).sapwood);
    fprintf(fid, '%s\n', 'DATA:Tree');
    l=length(measurement(i).ringwidths);
    measurement(i).ringwidths(l+1:(ceil(l/10))*10)=0;
    for j=1:length(measurement(i).ringwidths)/10
        fprintf(fid, '   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f   %3.0f\n', ...
            measurement(i).ringwidths((j*10)-9:(j*10)));
    end
end
fclose(fid);

clear all
clc