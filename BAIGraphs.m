% BAI Analyse
run ImportFH;
% locatie voor bestanden kiezen
[filename, pathname] = uiputfile({'*.*', 'All Files (*.*)'}, 'Choose Folder and filename if needed');
% grafieken locatie
eval(['mkdir ' '''' pathname 'BAI' '''' ]);
BAI_Matrix=BAIMatrix((seriesmatrix/1000)); % in centimeters
BAI_Matrix(1,:)=BAI_Matrix(1,:)*1000;
FiveMean_Matrix=FiveMeanMatrix(BAI_Matrix);
[x y]=size(FiveMean_Matrix);
q=ceil(x/5);
figure('units','pixels','Position',[0 0 1200 1200]);
for i=2:x
    subplot(q,5,i-1);
    plot(FiveMean_Matrix(1,:), FiveMean_Matrix(i,:))
    set(gca,'xlim', [FiveMean_Matrix(1,1) FiveMean_Matrix(1,y)]);
%    set(ax1, 'xlim', [FiveMean_Matrix(1,1) FiveMean_Matrix(1,y)]);
    title(label{i-1});
end
% Grafiek Printen
set(gcf, 'InvertHardCopy', 'off');
grafiek=['print -f1 -r900 -depsc ''' pathname 'BAI/' filename '_BAI_FiveYearMean' '''' ];
eval(grafiek);
% BAI als columnfile
BAIFile=[filename '_BAI.txt'];
fid = fopen([pathname 'BAI/' BAIFile], 'wt');
fprintf(fid, '%s\n', 'TreeRingSeries;Year;BAI(cm2)');
for i=2:x    
    for j=1:y
        if ~isnan(BAI_Matrix(i,j))
            fprintf(fid, '%s%s%1.0f%s%6.5f\n', label{i-1}, ';', BAI_Matrix(1,j),';', BAI_Matrix(i,j));
        end
    end
end
fclose(fid);
clear i j x y grafiek 