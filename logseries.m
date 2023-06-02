function [logtreering]=logseries(treeringseries)
[a,b]=size(treeringseries);
logtreering=nan(a,b);
logtreering(1,:)=treeringseries(1,:);
for teller=2:a;
    logtreering(teller,:)=log10(treeringseries(teller,:));
end