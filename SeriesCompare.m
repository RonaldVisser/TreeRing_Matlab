% Autatisch vergelijkingsscript met input mogelijkheid
[filename, pathname] = uiputfile({'*.*', 'All Files (*.*)'}, 'Choose Folder and Filenaam for csv(no extension)');
maat=size(seriesmatrix);
Passend(1,:)={'Code1' 'Code2' 'overlap' 'r' 'r(wuchs)' 't' 't(wuchs)' 'glk' 'p'};
k=2; 
%standardseries=mean0var1(seriesmatrix);
for i=2:(maat(1))
    for j=2:(maat(1))
        if i==j
        elseif i<j
            [nr r]=correlatie(seriesmatrix(i,:),seriesmatrix(j,:),20);
            [nglk glk]=gleichlaufich(seriesmatrix(i,:),seriesmatrix(j,:),25);
            s=1/(2*sqrt(nglk));
            z=((glk/100)-0.5)/s;
            p=2*(1-normcdf(z,0,1));
            if nr > 21 && p<1
                figure('units','pixels','Position',[100 100 900 700]);
                [nwr wr]=correlatie(wuchswerte(seriesmatrix(i,:)),wuchswerte(seriesmatrix(j,:)),25);
                [nt t]=tvalue(seriesmatrix(i,:),seriesmatrix(j,:),25);
                [nwt wt]=tvalue(wuchswerte(seriesmatrix(i,:)),wuchswerte(seriesmatrix(j,:)),25);
                [nglk glk]=gleichlaufich(seriesmatrix(i,:),seriesmatrix(j,:),25);
                s=1/(2*sqrt(nglk));
                z=((glk/100)-0.5)/s;
                p=2*(1-normcdf(z,0,1));
                subplot(2,1,1);  
                semilogy(seriesmatrix(1,:),seriesmatrix(i,:),seriesmatrix(1,:),seriesmatrix(j,:));
                
                % GLK areas grey
                hold on;
                maxy=max([nanmax(seriesmatrix(i,:)) nanmax(seriesmatrix(j,:))]);
                for glkarea=1:length(seriesmatrix(i,:)-1)
                    if seriesmatrix(i,glkarea)>seriesmatrix(i,glkarea+1) && seriesmatrix(j,glkarea)>seriesmatrix(j,glkarea+1)
                        bar(glkarea,maxy,1,'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');
                    elseif seriesmatrix(i,glkarea)<seriesmatrix(i,glkarea+1) && seriesmatrix(j,glkarea)<seriesmatrix(j,glkarea+1)
                        bar(glkarea,maxy,1,'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');
                    end
                end
                semilogy(seriesmatrix(1,:),seriesmatrix(i,:),seriesmatrix(1,:),seriesmatrix(j,:));
                clear maxy glkarea;
                legend(char(label(i-1)),char(label(j-1)),'Location','Best');
                hold off;
                subplot(2,1,2);                
                plot(seriesmatrix(1,:),seriesmatrix(i,:),seriesmatrix(1,:),seriesmatrix(j,:));           
                title({['Overlap: ', num2str(nr)]; ['r= ',num2str(r),', r(Wuchs)= ',num2str(wr)];['t= ',num2str(t), ', t(Wuchs)= ',num2str(wt)]; ['Gleichläufichkeit: ',num2str(glk), ' met p=',num2str(p)]})
%                subplot(3,1,3);
%                plot(standardseries(1,:),standardseries(i,:),standardseries(1,:),standardseries(j,:));        
                Keuze = input('Do these curves combine? Y/N [Y]: ', 's');
                if isempty(Keuze)
                    Keuze = 'Y';
                end
                if Keuze == 'Y'|Keuze == 'y'
                    Passend(k,:)=[label(i-1) label(j-1) nr r wr t wt glk p];
                    Passends(k-1,:)=[i-1 j-1];
                    k=k+1;
                    Kommando=['print -f1 -r600 -depsc ''' label{i-1} '_' label{j-1} '''' ];                  
                    eval(Kommando);             
                    close
                elseif Keuze == 'N'|Keuze == 'n'
                    close
                end
            end
        end
    end
end
clear i j k nr r nwr wr nt t nwt wt nglk glk Keuze Kommando p s z

%N=hist([Passends(:,1);Passends(:,2)],unique([Passends(:,1);Passends(:,2)]))
%L=unique([Passends(:,1);Passends(:,2)])'
%MeesteMatches=L(N==max(N))

%Passends2=[Passends;Passends(:,2),Passends(:,1)]
% Alles plaatsen in csv file
[x y] = size(Passend);
Statistiek=[filename '_Statistics.txt'];
fid = fopen([pathname Statistiek], 'wt');
for i=1:x
    if i==1
        fprintf(fid, '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n', Passend{i,1}, ';', Passend{i,2}, ';', Passend{i,3}, ';', Passend{i,4}, ';', Passend{i,5}, ';', Passend{i,6}, ';', Passend{i,7}, ';', Passend{i,8}, ';', Passend{i,9});
    else
        fprintf(fid, '%s%s%s%s%1.0f%s%6.5f%s%6.5f%s%6.5f%s%6.5f%s%6.4f%s%9.8f\n', Passend{i,1}, ';', Passend{i,2}, ';', Passend{i,3}, ';', Passend{i,4}, ';', Passend{i,5}, ';', Passend{i,6}, ';', Passend{i,7}, ';', Passend{i,8}, ';', Passend{i,9});
    end
end
clear i x y;
[x y] = size(Passend);
fclose(fid);
Links=[filename '_Links.txt'];
fid = fopen([pathname Links], 'wt');
fprintf(fid, '%s\n', 'Code1;Code2');
for i=1:x
    fprintf(fid, '%1.0f%s%1.0f\n', Passends(i,1), ';', Passends(i,2));
end
clear i x y;
