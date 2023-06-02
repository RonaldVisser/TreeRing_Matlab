% Script to import heidelberg(fh) in MATLAB

[FileName,PathName] = uigetfile('*.*','Select tree ring file');
tic;
FHFile=[PathName, FileName];
fid = fopen(FHFile,'r');
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
        case 0
            X=999;
        otherwise
            B=char(A{1});
            C=find(B=='=');
            measurement(i).(B(1:C-1))=B(C+1:end);            
    end
end
fprintf('%s %1.0f %s\n','Congratulation, you have successfully imported',i-1, 'measurements.')
toc
