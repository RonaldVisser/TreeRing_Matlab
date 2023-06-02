% grafieken overeenkomst
[xPas yPas] = size(Passends);
[xlab ylab] = size(label);
Passend2=Passend;
for h=1:xPas
    if Passend2{h,5} <0
        Passend2{h,5} = 0.0001
    end
    if Passend2{h,7} <0
        Passend2{h,7} = 0.0001
    end
end
x=[0 100];
kleur=['rgbcmyk'];
k=1;
for q=1:5
    if q==1
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends{i,:}], ' '''color''' ', kleur(k), ' '''LineWidth''' ', (Passend2{i,5}*3)' ')']
%        lijn=['plot(x,(Passends(i,:)),kleur(k),''' 'LineWidth''' ', (Passend{i+1,5}*3))']
        titel=['Lijndikte gebaseerd op correlatie (wuchswerte)']
        grafiek=['print -f1 -r600 -depsc ''' pathname filename '_match_correlatie' '''' ]
    elseif q==2
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends{i,:}], ' '''color''' ', kleur(k), ' '''LineWidth''' ', (Passend2{i,7}/4))']
%        lijn=['plot(x,(Passends(i,:)),kleur(k),''' 'LineWidth''' ', (Passend{i+1,7}/4))']
        titel=['Lijndikte gebaseerd op t-value (wuchswerte)']
        grafiek=['print -f1 -r600 -depsc ''' pathname filename '_match_t_wuchs' '''' ]
    elseif q==3
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends{i,:}], ' '''color''' ', kleur(k), ' '''LineWidth''' ', (Passend{i,8}/100)*2.5)']
%        lijn=['plot(x,(Passends(i,:)),kleur(k),''' 'LineWidth''' ', (Passend{i+1,8}/100)*2.5)']
        titel=['Lijndikte gebaseerd op gleichläufichkeit']
        grafiek=['print -f1 -r600 -depsc ''' pathname filename '_match_gleichlauf' '''' ]
    elseif q==4
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends{i,:}], ' '''color''' ', kleur(k), ' '''LineWidth''' ', ((1-(Passend{i,9}))^4)*4)']
%        lijn=['plot(x,(Passends(i,:)),kleur(k),''' 'LineWidth''' ', ((1-(Passend{i+1,9}))^4)*4)']
        titel=['Lijndikte gebaseerd op probability(gleichläufichkeit)']
        grafiek=['print -f1 -r600 -depsc ''' pathname filename '_match_probal' '''' ]
    else
        figure('units','pixels','Position',[0 0 900 700]);
        lijn=['line(x,[Passends{i,:}], ' '''color''' ', kleur(k))']
%        lijn=['plot(x,(Passends(i,:)),kleur(k))']
    end

    for i=2:xPas
            
    if i==2
        eval(lijn);
        ax1 = gca
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
        if Passends{i,1}==Passends{i-1,1}
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
