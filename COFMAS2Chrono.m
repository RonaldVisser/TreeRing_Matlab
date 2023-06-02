clear all
close all
[PathName]=uigetdir;
Files=dir(PathName);
[q p]=size(Files);
%[filename, pathname] = uiputfile({'*.txt', 'Textfile for import in database(*.txt)'; ...
%    '*.*', 'All Files (*.*)'}, 'Enter a filename');
fid2 = fopen([PathName '/chrono.txt'], 'wt');
fprintf(fid2, '%s\n', 'keycode;radius;date;position;value');
for i=3:q;
    x=strfind(Files(i).name, '_final_COF.MAS');
    if ~isempty(x)
        MeanName=Files(i).name(1:x-1);
        MeanFile=[PathName, '/', Files(i).name];
        fid = fopen(MeanFile,'r');
        A = textscan(fid,'%s');
        A=A{1};
        pos=1;
        for j = 1:2:length(A)
            if str2num(A{j})<1
                datering=str2num(A{j})-1;
                datering=num2str(datering);
            else
                datering=A{j};
            end
            fprintf(fid2, '%s%s%s%s%1.0f%s%1.0f\n', MeanName, ';C;', datering, ';', pos, ';', (str2num(A{j+1})+10)*10 );
            pos=pos+1;
        end
    end
end
