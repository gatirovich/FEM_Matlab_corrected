clc 
clear all
close all
q=0;
kcoef=1.0;
nex=95; % numero de elementos en x
ney=95; % numero de elementos en y
net=nex*ney; % numero total de elementos
nx=(nex + 1); % numero de nodos en x
ny=(ney + 1); % numero de nodos en y
nn=nx*ny; % numero de nodos totales 
Lx=1.0;Ly=1.0; % longitudes
dx=Lx/nex; 
dy=Ly/ney;
xe=zeros(2*nn,1); % vector posicion en maya
u=zeros(nn,1);    % vector solucion
ii=0;
nbc=zeros(nn,1);  % condiciondes de frontera
jj=0;jnb=0;
for j=1:ny
   
    for i=1:nx
        ii=ii + 1;%jj=jj +1;
        xe(2*ii-1,1)=dx*(i-1);
        xe(2*ii,1)=dy*(j-1);
         % nodos internos
         plot(xe(2*ii-1),xe(2*ii),'-s','MarkerEdgeColor','b','MarkerSize',10,'MarkerFaceColor',[1 1 1])
         hold on
         
         if ( xe(2*ii-1,1)<=Lx && xe(2*ii,1)== Ly ) % frontera
        jnb=jnb+1; % contador para frontera
        nbc(jnb,1)=ii; % posicion del nodo en la frontera
        u(ii,1)=1.0; % valor en ela frontera
        plot(xe(2*nbc(jnb,1)-1),xe(2*nbc(jnb,1)),'-s','MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor',[1 0.0 0.0])
        hold on
         elseif( xe(2*ii-1,1)==0.0 && xe(2*ii,1)<= Ly )%xe(2*ii-1,1)==Lx & xe(2*ii,1)<= Ly)
             jnb =jnb +1;
             nbc(jnb,1)=ii;
             u(ii,1)=0;
             plot(xe(2*nbc(jnb,1)-1),xe(2*nbc(jnb,1)),'-s','MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor',[0.1 0.1 0.0])
             hold on
          elseif( xe(2*ii-1,1)==Lx && xe(2*ii,1)<= Ly)
            jnb =jnb +1;
            nbc(jnb,1)=ii;
            plot(xe(2*nbc(jnb,1)-1),xe(2*nbc(jnb,1)),'-s','MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor',[0.1 0.1 0.0])
            hold on
        elseif (xe(2*ii-1,1)<=Lx && xe(2*ii,1)== 0.0)
         jnb=jnb+1;
         nbc(jnb,1)=ii;
        u(ii,1)=0.0;
         plot(xe(2*nbc(jnb,1)-1),xe(2*nbc(jnb,1)),'-s','MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor',[0.1 0.1 0.0]) 
        end
             
        
    end 
end
hold on
%  nbc
%  pause
% xe'
% axis([0 (Lx + 0.5*dx) 0 (Ly + 0.5*dy)])
% figure(2)
nee=zeros(net,4);
ii=1;

% matriz de concectividad y ensamble
for i=1:nex
    for j=1:ney
    xi=dx*(i-1) + 0.5*dx;
    yi=dy*(j-1)+ 0.5*dy;
    
     for k=1:nn
     dxe = xi - xe(2*k-1);
     dye = yi - xe(2*k);
     
     if(abs(dxe-0.5*dx)<1e-6 && abs(dye+0.5*dy)<1e-6 ) 
         nee(ii,4)=k;
     end
     
     if (abs(dxe+0.5*dx)<1e-6 && abs(dye+0.5*dy)<1e-6)
          nee(ii,3)=k;
     end
     if ((abs(dxe-0.5*dx)<1e-6 && abs(dye-0.5*dy)<1e-6))
          nee(ii,1)=k;
     end
     
     if((abs(dxe+0.5*dx)<1e-6 && abs(dye-0.5*dy)<1e-6))
          nee(ii,2)=k;
     end
     
     end
     ii =ii +1;
%      i
%      j
%     plot(xi,yi,'s')
%     hold on
    end
end
% axis([0.5*dx (Lx + 0.5*dx) 0.5*dy (Ly + 0.5*dy)])
% enlace numero de nodos
ni=4;
xee=zeros(ni,2);
for i=1:net
   for j=1:ni
%        xe(2*nee(i,j)-1);
%        xe(2*nee(i,j));
       xee(j,1)=xe(2*nee(i,j)-1);
       xee(j,2)=xe(2*nee(i,j));
   end
   face = [1 2 3 4];
%figure
patch('Faces',face,'Vertices',xee,'EdgeColor','red','FaceColor','none','LineWidth',1);
hold on
end
% pause
%kee=zeros(nn,nn);qee=zeros(nn,1);
%% --------colprt, CSC -----ensamble 
n_colptr = nn + 1;
n_max    = 9*nn;

% Reservar e inicializar los vectores columna
colptr(1:n_colptr,1) = 0;
rowind(1:n_max,1)    = 0;
nzval(1:n_max,1)     = 0.0;
frontera(1:nn,1)    = 0;
qee(1:nn,1)        = 0.0;

% Marcar los nodos con Dirichlet
for ib = 1:jnb
    nodo = nbc(ib,1);
    frontera(nodo,1) = 1;
    qee(nodo,1) = u(nodo,1);
end

% Contador de posiciones ocupadas en rowind y nzval
nalm = 0;
colptr(1,1) = 0;


% Construir CSC en base cero
nalm = 0;
colptr(1,1) = 0;

for jc = 1:ny
    for ic = 1:nx

        columna = (jc-1)*nx + ic;

        for jf = jc-1:jc+1
            for ifila = ic-1:ic+1

                if jf >= 1 && jf <= ny && ifila >= 1 && ifila <= nx
                    fila = (jf-1)*nx + ifila;

                    if frontera(fila) == 0 || fila == columna
                        nalm = nalm + 1;
                        rowind(nalm,1) = fila - 1;
                        nzval(nalm,1) = 0.0;

                        if frontera(fila) == 1
                            nzval(nalm,1) = 1.0;
                        end
                    end
                end

            end
        end

        colptr(columna+1,1) = nalm;
    end
end


nf=4;
 for i=1:net
ke=zeros(nf,nf);
qe=zeros(nf,1);
dfdx=zeros(nf,2);
f=zeros(nf,1);
knee=zeros(nf,nf);

 ni=2;
 xi=zeros(ni,2);
 wi=ones(ni,2);
 wi(:,1)=1;

 xi(1,1)= -sqrt(1/3);%xi(2)=0;
 xi(1,2)=  -sqrt(1/3);
 xi(2,1)=   sqrt(1/3);%xi(2)=0;
 xi(2,2)=  sqrt(1/3);
% ensamble del vector qee
% for k1=1:nf
%     int_k =0;
%     % integracion mediante cuadratura
%     for ii=1:ni
%         for jj=1:ni
%           xii= xi(ii,1);% variable ξ
%                 yii= xi(jj,2); % variable η
%                 %% funciones de interpolacion y sus derivadas
%                 f(1)=0.25*(1-xii)*(1-yii);dfdx(1,1)=-0.25*(1-yii);dfdx(1,2)=-0.25*(1-xii);
%                 f(2)=0.25*(1+xii)*(1-yii);dfdx(2,1)=0.25*(1-yii);dfdx(2,2)=-0.25*(1+xii);
%                 f(3)=0.25*(1+xii)*(1+yii);dfdx(3,1)=0.25*(1+yii);dfdx(3,2)=0.25*(1+xii);
%                 f(4)=0.25*(1-xii)*(1+yii);dfdx(4,1)=-0.25*(1+yii);dfdx(4,2)=0.25*(1-xii);
%                 %% calcular la matrix jacobiana J, la inversa y el Jacobiano det(J)
%                 for i1=1:2
%                     jnx=0.0;jny=0.0;
%                     for j1=1:nf
%                         jnx = jnx + xe(2*nee(i,j1)-1,1)*dfdx(j1,i1);
%                         jny = jny + xe(2*nee(i,j1),1)*dfdx(j1,i1);
%                     end
%                     Jacb(i1,1)=jnx; %#ok<SAGROW>
%                     Jacb(i1,2)=jny; %#ok<SAGROW>
%                 end
%                 iJacb=inv(Jacb); % determiante de la matriz
%                 jdet=det(Jacb); % determinante jacobainao
%                 int_k = int_k + jdet*0.5*wi(ii,1)*wi(jj,1)*0.0*f(k1);
%         end
%     end
 %% Ensamble de qee
%            qe(k1,1)=int_k;
% 
%             for ii=1:nn
% 
%                     if (ii==nee(i,k1) )
%                          qee(ii,1)=qee(ii,1) +   0.0;
%                     end
% 
%             end
% end

Jacb=zeros(2,2);
  
 for k1=1:nf
    for k2=1:nf
        
   int_k=0.0;     
 for ii=1:ni
      for jj=1:ni
     xii=(xi(ii,1));
     yii=(xi(jj,2));
     f(1)= 0.25*(1-xii)*(1-yii);dfdx(1,1)=-0.25*(1-yii);dfdx(1,2)=-0.25*(1-xii);
     f(2)= 0.25*(1+xii)*(1-yii);dfdx(2,1)=0.25*(1-yii);dfdx(2,2)=-0.25*(1+xii);
     f(3)= 0.25*(1+xii)*(1+yii);dfdx(3,1)=0.25*(1+yii);dfdx(3,2)=0.25*(1+xii);
     f(4)= 0.25*(1-xii)*(1+yii);dfdx(4,1)=-0.25*(1+yii);dfdx(4,2)=0.25*(1-xii);
     for j1=1:2
         jnx=0;jny=0;
             for i1=1:4
             jnx = jnx +xe(2*nee(i,i1)-1)*dfdx(i1,j1);
             jny = jny +xe(2*nee(i,i1))*dfdx(i1,j1);
             end
             Jacb(j1,1)=jnx;
             Jacb(j1,2)=jny;
     end

     jd=det(Jacb); % determinante jacobiano
     iJacob=inv(Jacb);
     dxx=(iJacob(1,1)*dfdx(k1,1) + iJacob(1,2)*dfdx(k1,2))*(iJacob(1,1)*dfdx(k2,1) + iJacob(1,2)*dfdx(k2,2) );
     dyy=(iJacob(2,1)*dfdx(k1,1) + iJacob(2,2)*dfdx(k1,2))*(iJacob(2,1)*dfdx(k2,1) + iJacob(2,2)*dfdx(k2,2) );
     int_k =  int_k + jd*0.5*wi(ii,1)*wi(jj,2)*(kcoef*dxx + kcoef*dyy); 
      end
 end
 %% ensamble de Ke
 %ke(k1,k2)=int_k;
 % fila    = nee(i,k1);
 % columna = nee(i,k2);

 % Las filas de Dirichlet ya quedaron con un 1 en la diagonal.
 if frontera(nee(i,k1)) == 0
     p_ini = colptr(nee(i,k2)) + 1;
     p_fin = colptr(nee(i,k2)+1);

     for p = p_ini:p_fin
         if rowind(p) == nee(i,k1) - 1
             nzval(p) = nzval(p) + int_k;
             break
         end
     end
 end
 % for ii=1:nn
 %     for jj=1:nn
 % 
 %       if(ii==nee(i,k1) && jj==nee(i,k2)) 
 %           kee(ii,jj)=  kee(ii,jj) + ke(k1,k2);
 %if(ii==nee(i,k1) && jj==nee(i,k2)) 
 %kee(nee(i,k1),nee(i,k2))=  kee(nee(i,k1),nee(i,k2)) + int_k;
 %end
 %       end
 %     end
 % end
    end
 end

  
 end

nnz_csc = nalm;

rowind = rowind(1:nnz_csc,1);
nzval  = nzval(1:nnz_csc,1);
%%
nodo_prueba = nx + 2;  % Segundo nodo en x, segundo en y
diagonal = 0.0;

for p = colptr(nodo_prueba)+1 : colptr(nodo_prueba+1)
    if rowind(p) == nodo_prueba - 1
        diagonal = nzval(p);
        break
    end
end

assert(diagonal > 0, 'La diagonal interior no recibió el aporte FEM.');
%%
%% condiciones de frontera
% for i=1:jnb
%     ii=nbc(i,1);
%     kee(ii,:)=0.0;
%     kee(ii,ii)=1;
%     qee(ii,1)=u(ii,1);
% end
producto = @(x) producto_csc(nn,colptr,rowind,nzval,x);

reinicio = min(50,nn);
tol = 1e-10;
max_ciclos = 30;

[u(:),flag,relres] = gmres(producto,qee,reinicio,tol,max_ciclos);

if flag ~= 0
    error('GMRES no convergió. flag = %d, residuo relativo = %.3e', ...
          flag,relres);
end
%% solucion del sistema de ecuaciones
%u=inv(kee)*qee; %#ok<MINV>

%% Interpolacion-postprocesamiento
Tint = TriScatteredInterp( xe(1:2:2*nn - 1),xe(2:2:2*nn),u,'natural'); %#ok<DTRIINT>

 ni = 70;dx = Lx/(ni - 1);
 [x y] = meshgrid(0:dx:Lx,0:dx:Lx);
 um=zeros(ni,ni);
for i = 1: ni
    for j = 1:ni
        um(i,j) = Tint( x(i,j), y(i,j) );
    end
end
figure; 
axes('FontSize',18,'LineWidth',1.5');
hold on;
contourf(x,y,um)
axis([0 1 0 1]);
xlabel('x','FontSize',18)
ylabel('y','FontSize',18)
colorbar
%%%%
%
function y = producto_csc(nn,colptr,rowind,nzval,x)

    y = zeros(nn,1);

    for j = 1:nn
        p_ini = colptr(j) + 1;
        p_fin = colptr(j+1);

        for p = p_ini:p_fin
            fila = rowind(p) + 1;
            y(fila) = y(fila) + nzval(p)*x(j);
        end
    end

end
%
