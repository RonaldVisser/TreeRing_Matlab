% locatie voor bestanden kiezen
%[filename, pathname] = uiputfile({'*.*', 'All Files (*.*)'}, 'Choose Folder and Filenaam for csv(no extension)');

% grafieken overeenkomst kleuren per groep
% 6 kleuren beschikbaar, van laag naar hoog: yellow, green, cyan, blue, magenta,
% red (ygcbmr)
[xPas yPas] = size(Passends);
[xlab ylab] = size(label);
Passend2=[Passend(:,1:3) Passend(:,5) Passend(:,7:end)];
for h=1:xPas
    if Passend2{h,4} <0
        Passend2{h,4} = 0.0001
    end
    if Passend2{h,5} <0
        Passend2{h,5} = 0.0001
    end
end

x=[0 100];
kleur=['ygcbmrw'];
% klasses voor kleuren
klasse=[0.3 0.4 0.5 0.6 0.7 0.8;4 6 8 10 12 14;60.5 64 67.5 71 74.5 78;0.01 0.05 0.001 0.0005 0.00025 0.0001];

for q=1:4
    figure('visible', 'off', 'units','pixels','Position',[0 0 900 700]);
    lijn=['line(x,[Passends(i-1,:)], ' '''color''' ', kleur(k))'];
    lijn2=['line(x,[Passends(i-1,2) Passends(i-1,1)], ' '''color''' ', kleur(k))'];
    for i=2:xPas
        if Passend2{i,q+3} >= klasse(q,6)            
                k=6; % red
        elseif Passend2{i,q+3} < klasse(q,6) && Passend2{i,q+3} >= klasse(q,5)
                k=5; % magenta
        elseif Passend2{i,q+3} < klasse(q,5) && Passend2{i,q+3} >= klasse(q,4)
                k=4; % blue
        elseif Passend2{i,q+3} < klasse(q,4) && Passend2{i,q+3} >= klasse(q,3)
                k=3; % cyan
        elseif Passend2{i,q+3} < klasse(q,3) && Passend2{i,q+3} >= klasse(q,2)
                k=2; % green
        elseif Passend2{i,q+3} < klasse(q,2) && Passend2{i,q+3} >= klasse(q,1)
                k=1; % yellow
        else
            k=7; % white and not visible
        end
        if i==2
            eval(lijn);
            ax1 = gca;     
            set(ax1, 'ylim', [1 xlab]);
            set(ax1, 'XTick', x, 'XTicklabel', [], 'YTick',[1:xlab],'YTicklabel', label(1:xlab));
            ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none','XColor','k','YColor','k');
            set(ax2, 'ylim', [1 xlab]);
            set(ax2, 'XTick', x, 'XTicklabel', [], 'YTick',[1:xlab],'YTicklabel', label(1:xlab));
            hold on;
            eval(lijn2);
            if q==1
                titel=['Lijnkleur gebaseerd op correlatie (wuchswerte) (' filename ')'];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename '_kleur_correlatie' '''' ];
                legenda=['print -f1 -r600 -depsc ''' pathname filename '_kleur_correlatie_legenda' '''' ];
            elseif q==2
                titel=['Lijnkleur gebaseerd op t-value (wuchswerte) (' filename ')'];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename 'kleur_t_wuchs' '''' ];
                legenda=['print -f1 -r600 -depsc ''' pathname filename '_kleur_t_wuchs_legenda' '''' ];
            elseif q==3
                titel=['Lijnkleur gebaseerd op gleichaufichkeit (' filename ')' ];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename '_kleur_gleichlauf' '''' ];
                legenda=['print -f1 -r600 -depsc ''' pathname filename '_kleur_gleichlauf_legenda' '''' ];
            elseif q==4
                titel=['Lijnkleur gebaseerd op probability(gleichlaufichkeit) (' filename ')'];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename '_kleur_probal' '''' ];
                legenda=['print -f1 -r600 -depsc ''' pathname filename '_kleur_probal_legenda' '''' ];
            else
                titel=['Geen variatie in lijnkleur)'];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename '_geenlijnkleur' '''' ];
                legenda=['print -f1 -r600 -depsc ''' pathname filename '_geenlijnkleur_legenda' '''' ];
            end
        title(titel,'FontWeight','bold');
        hold on;
%        legend(['> ' num2str(klasse(q,6))],[num2str(klasse(q,5)) '-' num2str(klasse(q,6))], [num2str(klasse(q,4)) '-' num2str(klasse(q,5))], [num2str(klasse(q,3)) '-' num2str(klasse(q,4))], [num2str(klasse(q,2)) '-' num2str(klasse(q,3))], [num2str(klasse(q,1)) '-' num2str(klasse(q,2))], ['< ' num2str(klasse(q,1)) ' (white)'], 'Interpreter', 'none', 'Location', 'EastOutside');
        else
            eval(lijn);
            eval(lijn2);
        end
    end
    set(gcf, 'InvertHardCopy', 'off');
%    legend(['> ' num2str(klasse(q,6))],[num2str(klasse(q,5)) '-' num2str(klasse(q,6))], [num2str(klasse(q,4)) '-' num2str(klasse(q,5))], [num2str(klasse(q,3)) '-' num2str(klasse(q,4))], [num2str(klasse(q,2)) '-' num2str(klasse(q,3))], [num2str(klasse(q,1)) '-' num2str(klasse(q,2))], ['< ' num2str(klasse(q,1)) ' (white)'], 'Interpreter', 'none', 'Location', 'EastOutside');
    eval(grafiek);
    close;
    figure('visible', 'off');
    for u=6:-1:1
        line(x,[u u], 'color', kleur(u));
        hold on;
    end
    legend(['> ' num2str(klasse(q,6))],[num2str(klasse(q,5)) '-' num2str(klasse(q,6))], [num2str(klasse(q,4)) '-' num2str(klasse(q,5))], [num2str(klasse(q,3)) '-' num2str(klasse(q,4))], [num2str(klasse(q,2)) '-' num2str(klasse(q,3))], [num2str(klasse(q,1)) '-' num2str(klasse(q,2))], ['< ' num2str(klasse(q,1))], 'Interpreter', 'none', 'Location', 'EastOutside');
    eval(legenda);
    close;
end

% alleen beste 2 klasses in grafiek
k=1;
kleur=['ygcbmrw'];
for q=1:4
    figure('visible', 'off', 'units','pixels','Position',[0 0 900 700]);
    lijn=['line(x,[Passends(i-1,:)], ' '''color''' ', kleur(k))'];
    lijn2=['line(x,[Passends(i-1,2) Passends(i-1,1)], ' '''color''' ', kleur(k))'];
    for i=2:xPas
        if Passend2{i,q+3} >= klasse(q,6)            
            k=6; % red
            lijn=['line(x,[Passends(i-1,:)], ' '''color''' ', kleur(k))'];
            lijn2=['line(x,[Passends(i-1,2) Passends(i-1,1)], ' '''color''' ', kleur(k))'];
        elseif Passend2{i,q+3} < klasse(q,6) && Passend2{i,q+3} >= klasse(q,5)
            k=5; % cyan
            lijn=['line(x,[Passends(i-1,:)], ' '''color''' ', kleur(k))'];
            lijn2=['line(x,[Passends(i-1,2) Passends(i-1,1)], ' '''color''' ', kleur(k))'];
%        elseif Passend2{i,q+3} < klasse(q,5) && Passend2{i,q+3} >= klasse(q,4)
%            k=4; % blue
%            lijn=['line(x,[Passends(i-1,:)], ' '''color''' ', kleur(k))'];
%            lijn2=['line(x,[Passends(i-1,2) Passends(i-1,1)], ' '''color''' ', kleur(k))'];
        else
%            k=7; % white and not visible
            llijn=['lijn'];
            lijn2=['lijn'];
        end
        if i==2
            eval(lijn);
            ax1 = gca;          
            set(ax1, 'ylim', [1 xlab]);
            set(ax1, 'XTick', x, 'XTicklabel', [], 'YTick',[1:xlab],'YTicklabel', label(1:xlab));
            ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none','XColor','k','YColor','k');
            set(ax2, 'ylim', [1 xlab]);
            set(ax2, 'XTick', x, 'XTicklabel', [], 'YTick',[1:xlab],'YTicklabel', label(1:xlab));
            hold on;
            eval(lijn2);
            if q==1
                titel=['Lijnkleur gebaseerd op correlatie (wuchswerte) (' filename ')'];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename '_kleur_best_correlatie' '''' ];
            elseif q==2;
                titel=['Lijnkleur gebaseerd op t-value (wuchswerte) (' filename ')'];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename 'kleur_best_t_wuchs' '''' ];
            elseif q==3
                titel=['Lijnkleur gebaseerd op gleichaufichkeit (' filename ')'];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename '_kleur_best_gleichlauf' '''' ];
            elseif q==4
                titel=['Lijnkleur gebaseerd op probability(gleichlaufichkeit) (' filename ')'];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename '_kleur_best_probal' '''' ];
            else
                titel=['Geen variatie in lijnkleur)'];
                grafiek=['print -f1 -r600 -depsc ''' pathname filename '_geenlijnkleur' '''' ];
            end
        title(titel,'FontWeight','bold');
%        legend(['> ' num2str(klasse(q,6))],[num2str(klasse(q,5)) '-' num2str(klasse(q,6))], [num2str(klasse(q,4)) '-' num2str(klasse(q,5))], [num2str(klasse(q,3)) '-' num2str(klasse(q,4))], [num2str(klasse(q,2)) '-' num2str(klasse(q,3))], [num2str(klasse(q,1)) '-' num2str(klasse(q,2))], ['< ' num2str(klasse(q,1)) ' (white)'], 'Interpreter', 'none', 'Location', 'EastOutside');
        else
            eval(lijn);
            eval(lijn2);
        end
    end
    set(gcf, 'InvertHardCopy', 'off');
%    legend(['> ' num2str(klasse(q,6))],[num2str(klasse(q,5)) '-'
%    num2str(klasse(q,6))], [num2str(klasse(q,4)) '-' num2str(klasse(q,5))], [num2str(klasse(q,3)) '-' num2str(klasse(q,4))], [num2str(klasse(q,2)) '-' num2str(klasse(q,3))], [num2str(klasse(q,1)) '-' num2str(klasse(q,2))], ['< ' num2str(klasse(q,1)) ' (white)'], 'Interpreter', 'none', 'Location', 'EastOutside');
    eval(grafiek);
    close;
end

clear xPas yPas k i x ylab xlab q lijn grafiek titel kleur Passend2