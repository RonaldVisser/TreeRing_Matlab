% p.matrix for clustering
function p_mtx=pmatrix(GLK_mtx, overlap_mtx)
[x y]=size(overlap_mtx);
q=ones(x, y);
s_mtx=q./(2*sqrt(overlap_mtx));
z_mtx=((GLK_mtx/100)-0.5)./s_mtx;
p_mtx=2*(1-normcdf(z_mtx,0,1));