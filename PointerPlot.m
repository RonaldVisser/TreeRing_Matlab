% PointerPlot
plot(Pointer.Dates,Pointer.PSi)
hold all
plot(Pointer.Dates(PointerTypes.ExtremePointer),Pointer.PSi(PointerTypes.ExtremePointer),'*')
plot(Pointer.Dates(PointerTypes.StrongPointer),Pointer.PSi(PointerTypes.StrongPointer),'x')
plot(Pointer.Dates(PointerTypes.WeakPointer),Pointer.PSi(PointerTypes.WeakPointer),'>')
h=legend('PointerGraph','ExtremePointer','StrongPointer','WeakPointer');
set(h,'Interpreter','none');