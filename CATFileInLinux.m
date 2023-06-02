    [PathName]=uigetdir;
    Files=dir(PathName);
    [q p]=size(Files);
    for i=3:q;
        if Files(i).name(9:12) == '.DAT' | Files(i).name(9:12)=='.dat' 
            CATFile=[PathName, '/', Files(i).name];
            fid = fopen(CATFile,'r');
            A = fread(fid);
            measurement(i-2).measurement=char(A(33:40)');
            measurement(i-2).header=char(A(1:33)');
            if A(46)==1
                measurement(i-2).Length=binswitch(A(45));
            elseif A(46)==0
                measurement(i-2).Length=A(45);
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
                start=0;
                measurement(i-2).DateEnd=measurement.Length;
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