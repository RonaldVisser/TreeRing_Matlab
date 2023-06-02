% Automatisch vergelijkingsscript met input mogelijkheid
% Hierbij worden bestanden gecreerd met de overeenkomst, tot slot ook de
% Abrupt Growth Changes
% eerst fh openen
clear all;
clc;
close;
run ImportFH;
% locatie voor bestanden kiezen
[filename, pathname] = uiputfile({'*.*', 'All Files (*.*)'}, 'Choose Folder and Filenaam for csv(no extension)');
% grafieken locatie
eval(['mkdir ' '''' pathname 'graph' '''' ])
maat=size(seriesmatrix);
Passend(1,:)={'Code1' 'Code2' 'overlap' 'r' 'r(wuchs)' 't' 't(wuchs)' 'glk' 'p'};
k=2; 
for i=2:(maat(1))
    for j=2:(maat(1))
        if i==j
        elseif i<j
            [nr r]=correlatie(seriesmatrix(i,:),seriesmatrix(j,:),20);
            [nglk glk]=gleichlaufich(seriesmatrix(i,:),seriesmatrix(j,:),25);
            s=1/(2*sqrt(nglk));
            z=((glk/100)-0.5)/s;
            p=2*(1-normcdf(z,0,1));
            if nr > 21 && glk>58
                figure('units','pixels','Position',[100 100 900 700]);
                [nwr wr]=correlatie(wuchswerte(seriesmatrix(i,:)),wuchswerte(seriesmatrix(j,:)),25);
                [nt t]=tvalue(seriesmatrix(i,:),seriesmatrix(j,:),25);
                [nwt wt]=tvalue(wuchswerte(seriesmatrix(i,:)),wuchswerte(seriesmatrix(j,:)),25);
                [nglk glk]=gleichlaufich(seriesmatrix(i,:),seriesmatrix(j,:),25);
                s=1/(2*sqrt(nglk));
                z=((glk/100)-0.5)/s;
                p=2*(1-normcdf(z,0,1));
                subplot(2,1,1);  
                semilogy(seriesmatrix(1,:),seriesmatrix(i,:),seriesmatrix(1,:),seriesmatrix(j,:))
                legend(char(label(i-1)),char(label(j-1)),'Location','Best');
                % plot graph with normal axis
                subplot(2,1,2);                
                plot(seriesmatrix(1,:),seriesmatrix(i,:),seriesmatrix(1,:),seriesmatrix(j,:));           
                % GLK areas grey
                hold on;
                maxy=max([nanmax(seriesmatrix(i,:)) nanmax(seriesmatrix(j,:))]);
                for glkarea=1:length(seriesmatrix(1,:))-1
                    if seriesmatrix(i,glkarea)>seriesmatrix(i,glkarea+1) && seriesmatrix(j,glkarea)>seriesmatrix(j,glkarea+1)
                        bar([seriesmatrix(1,glkarea:glkarea+1)]+0.5,[maxy maxy],1,'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');
                    elseif seriesmatrix(i,glkarea)<seriesmatrix(i,glkarea+1) && seriesmatrix(j,glkarea)<seriesmatrix(j,glkarea+1)
                        bar([seriesmatrix(1,glkarea:glkarea+1)]+0.5,[maxy maxy],1,'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');
                    elseif seriesmatrix(i,glkarea)==seriesmatrix(i,glkarea+1) && seriesmatrix(j,glkarea)==seriesmatrix(j,glkarea+1)
                        bar([seriesmatrix(1,glkarea:glkarea+1)]+0.5,[maxy maxy],1,'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');
                    else
                        bar([seriesmatrix(1,glkarea:glkarea+1)]+0.5,[maxy maxy],1,'FaceColor', [1 1 1], 'EdgeColor', 'none');
                    end
                end
                plot(seriesmatrix(1,:),seriesmatrix(i,:),seriesmatrix(1,:),seriesmatrix(j,:));
                hold off;
                title({['Overlap: ', num2str(nr)]; ['r= ',num2str(r),', r(Wuchs)= ',num2str(wr)];['t= ',num2str(t), ', t(Wuchs)= ',num2str(wt)]; ['Gleichläufichkeit: ',num2str(glk), ' met p=',num2str(p)]})
                Keuze = input('Do these curves combine? Y/N [Y]: ', 's');
                if isempty(Keuze)
                    Keuze = 'Y';
                end
                if Keuze == 'Y'|Keuze == 'y'
                    Passend(k,:)=[label(i-1) label(j-1) nr r wr t wt glk p];
                    Passends(k-1,:)=[i-1 j-1];
                    k=k+1;
                    Kommando=['print -f1 -r600 -depsc ''' pathname 'graph/' label{i-1} '_' label{j-1} '''' ];                  
                    eval(Kommando)             
                    close
                elseif Keuze == 'N'|Keuze == 'n'
                    close
                elseif Keuze ~= 'N'|Keuze ~= 'n' | Keuze ~= 'Y' | Keuze ~= 'y'
                    beep;
                    Keuze = input('WRONG KEY!!! Do these curves combine? Y/N [Y]: ', 's');
                    if Keuze == 'Y'|Keuze == 'y'
                        Passend(k,:)=[label(i-1) label(j-1) nr r wr t wt glk p];
                        Passends(k-1,:)=[i-1 j-1];
                        k=k+1;
                        Kommando=['print -f1 -r600 -depsc ''' pathname 'graph/' label{i-1} '_' label{j-1} '''' ];                  
                        eval(Kommando)             
                        close
                    elseif Keuze == 'N'|Keuze == 'n'
                        close
                    end
                end
            end
        end
    end
end
clear i j k nr r nwr wr nt t nwt wt nglk glk Keuze Kommando p s z

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
clear i x y Statistiek;
[x y] = size(Passends);
fclose(fid);
Links=[filename '_Links.txt'];
fid = fopen([pathname Links], 'wt');
fprintf(fid, '%s\n', 'Code1;Code2');
for i=1:x
    fprintf(fid, '%1.0f%s%1.0f\n', Passends(i,1), ';', Passends(i,2));
end
clear i x y Links;

% grafieken overeenkomst
[xPas yPas] = size(Passends);
[xlab ylab] = size(label);
Passend2=Passend;
for h=1:xPas
    if Passend2{h,5} < 0 | isnan(Passend2{h,5})
        Passend2{h,5} = 0.0001;
    end
    if Passend2{h,7} < 0 | isnan(Passend2{h,7})
        Passend2{h,7} = 0.0001;
    end
end
    x=[0 100];
kleur=['rgbcmyk'];
k=1;
for q=1:5
    if q==1
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends(i,:)], ' '''color''' ', kleur(k), ' '''LineWidth''' ', (Passend2{i+1,5}*3)' ')'];
%        lijn=['plot(x,(Passends(i,:)),kleur(k),''' 'LineWidth''' ', (Passend{i+1,5}*3))']
        titel=['Lijndikte gebaseerd op correlatie (wuchswerte)'];
        grafiek=['print -f1 -r600 -depsc ''' pathname filename '_match_correlatie' '''' ];
    elseif q==2
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends(i,:)], ' '''color''' ', kleur(k), ' '''LineWidth''' ', (Passend2{i+1,7}/4))'];
%        lijn=['plot(x,(Passends(i,:)),kleur(k),''' 'LineWidth''' ', (Passend{i+1,7}/4))']
        titel=['Lijndikte gebaseerd op t-value (wuchswerte)'];
        grafiek=['print -f1 -r600 -depsc ''' pathname filename '_match_t_wuchs' '''' ];
    elseif q==3
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends(i,:)], ' '''color''' ', kleur(k), ' '''LineWidth''' ', (Passend{i+1,8}/100)*2.5)'];
%        lijn=['plot(x,(Passends(i,:)),kleur(k),''' 'LineWidth''' ', (Passend{i+1,8}/100)*2.5)']
        titel=['Lijndikte gebaseerd op gleichläufichkeit'];
        grafiek=['print -f1 -r600 -depsc ''' pathname filename '_match_gleichlauf' '''' ];
    elseif q==4
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends(i,:)], ' '''color''' ', kleur(k), ' '''LineWidth''' ', ((1-(Passend{i+1,9}))^4)*4)'];
%        lijn=['plot(x,(Passends(i,:)),kleur(k),''' 'LineWidth''' ', ((1-(Passend{i+1,9}))^4)*4)']
        titel=['Lijndikte gebaseerd op probability(gleichläufichkeit)'];
        grafiek=['print -f1 -r600 -depsc ''' pathname filename '_match_probal' '''' ];
    else
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends(i,:)], ' '''color''' ', kleur(k))'];
%        lijn=['plot(x,(Passends(i,:)),kleur(k))']
    end

    for i=1:xPas
            
    if i==1
        eval(lijn);
        ax1 = gca;
        set(ax1, 'ylim', [1 xlab]);
        set(ax1, 'XTick', x, 'XTicklabel', [], 'YTick',[1:xlab],'YTicklabel', label(1:xlab));
        ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none','XColor','k','YColor','k');
        set(ax2, 'ylim', [1 xlab]);
        set(ax2, 'XTick', x, 'XTicklabel', [], 'YTick',[1:xlab],'YTicklabel', label(1:xlab));
%        set(gca, 'XTick', x, 'XTicklabel', [], 'YTick',[1:xlab],'YTicklabel', label(1:xlab));
%        set(gca,'YGrid','on')
        title(titel,'FontWeight','bold');
        hold on;
    else
        if Passends(i,1)==Passends(i-1,1)
            eval(lijn);
        else
            k=k+1;
            if k<8                
                eval(lijn);
            else k==8
                k=1;
                eval(lijn);
            end
        end
    end
    end
    eval(grafiek);
    close;
end

clear xPas yPas k i x ylab xlab q lijn grafiek titel kleur Passend2

run SeriesGraphKleur.m

% Look for Abrupt Growth Change
[x y]=size(seriesmatrix);
AGCIndex=zeros(x,y);
AGCIndex(1,:)=seriesmatrix(1,:);
for i=2:x
    AGCIndex(i,:)=AGC(seriesmatrix(i,:));
end
clear i x y;
AGCIndex(AGCIndex==0)=NaN;
[x,y]=find(~isnan(AGCIndex(2:end,:)));
AGCFile=[filename '_AGC.txt'];
fid = fopen([pathname AGCFile], 'wt');
fprintf(fid, '%s\n', 'TreeRingSeries;Year;Neg_Pos');
for i=1:length(x)
    AGCWaardes(i,:)=[label(x(i)), AGCIndex(1,y(i)), AGCIndex(x(i)+1,y(i))];
    fprintf(fid, '%s%s%1.0f%s%1.0f\n', label{x(i)}, ';', AGCIndex(1,y(i)),';', AGCIndex(x(i)+1,y(i)));
end
fclose(fid);
clear i x y;
run SeriesGraphKleur;
clear fid filename maat pathname;