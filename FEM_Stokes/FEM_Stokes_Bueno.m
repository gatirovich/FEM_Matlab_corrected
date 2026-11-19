clc 
clear all
close all
q=0;
mu=0.0001;
nex=12;
ney=12;
net=nex*ney;
nx1=(2*nex + 1);
nx2=(nex + 1);
ny2=(ney +1);
ny=(2*ney + 1);
nn=nx1*ny-net;nnp=nx2*ny2;
Lx=1.0;Ly=1.0;
dx1=Lx/(2*nex);dx2=Lx/(nex);
dy1=Ly/(2*ney);dy2=Ly/(ney);
xe=zeros(2*nn,1);xep=zeros(nnp,1);
u=zeros(2*nn+(nex+1)*(ney+1),1);
ii=0;
nbc=zeros(nn,2);
jj=0;jnb=0;
%%%%%%%%%%%%%%%%%%%%% nodos velocidad%%%%%%%%%%%%%
for j=1:ny
    
    if (rem(j,2)==0)
        dx=dx2;dy=dy1;
        nx=nx2;
    else
        dx=dx1;dy=dy1;
        nx=nx1;
    end
    
    for i=1:nx
         ii=ii + 1;jj=jj +1;
       
        xe(2*ii-1,1)=dx*(i-1);
        xe(2*ii,1)=dy*(j-1);
         plot(xe(2*ii-1),xe(2*ii),'-s','MarkerEdgeColor','b','MarkerSize',10,'MarkerFaceColor',[1 1 1])
         hold on
         %plot(x,y,'-s','MarkerSize',10,'MarkerFaceColor',[1 1 1])
        if ( xe(2*ii-1,1)<=Lx & xe(2*ii,1)== Ly ) 
        jnb=jnb+1;
        nbc(jnb,1)=ii;
        u(ii,1)=1.0;
        u(nn+ii,1)=0.0;
        nbc(jnb,2)=1;
        plot(xe(2*nbc(jnb,1)-1),xe(2*nbc(jnb,1)),'-s','MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor',[1 0.0 0.0])
        hold on
        elseif( xe(2*ii-1,1)==0.0 & xe(2*ii,1)<= Ly )%xe(2*ii-1,1)==Lx & xe(2*ii,1)<= Ly)
            jnb =jnb +1;
            nbc(jnb,1)=ii;
            nbc(jnb,2)=1;
            u(ii,1)=0;
            u(nn+ii,1)=0.0;
            plot(xe(2*nbc(jnb,1)-1),xe(2*nbc(jnb,1)),'-s','MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor',[0.1 0.1 0.0])
            hold on
          elseif( xe(2*ii-1,1)==Lx & xe(2*ii,1)<= Ly)
            jnb =jnb +1;
            nbc(jnb,1)=ii;
            nbc(jnb,2)=1;
            u(ii,1)=0;
            u(nn+ii,1)=0.0;
            plot(xe(2*nbc(jnb,1)-1),xe(2*nbc(jnb,1)),'-s','MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor',[0.1 0.1 0.0])
            hold on
        elseif (xe(2*ii-1,1)<=Lx & xe(2*ii,1)== 0.0)
         jnb=jnb+1;
         nbc(jnb,1)=ii;
        u(ii,1)=0.0;
        u(nn+ii,1)=0.0;
        nbc(jnb,2)=0.0;
         plot(xe(2*nbc(jnb,1)-1),xe(2*nbc(jnb,1)),'-s','MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor',[0.1 0.1 0.0]) 
        end
        
         
          
        
    end 
end
 jnb
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% nodos presion%%%%%%%%%%%%%%%%%
 ii=0;jj=0;
 for j=1:ny2
   
    for i=1:nx2
        ii=ii + 1;jj=jj +1;
        xep(2*ii-1,1)=dx2*(i-1);
        xep(2*ii,1)=dy2*(j-1);

        
    end 
end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% u
%  pause
% xe'
% axis([0 (Lx + 0.5*dx) 0 (Ly + 0.5*dy)])
% figure(2)
nee=zeros(net,8); neep=zeros(net,4);
ii=1;iip=1; 
dx=dx2;dy=dy2;
%  pause
for i=1:nex
    for j=1:ney
    xi=dx*(i-1) + 0.5*dx;
    yi=dy*(j-1)+ 0.5*dy;
    %%%%%%%%%%%%%%%%% conectividad velocidad %%%%%%%%%%%%%%%%%%%%%%%%%%%%
     for k=1:nn
     dxe = xi - xe(2*k-1);
     dye = yi - xe(2*k);
     
     if(abs(dxe-0.5*dx)<1e-6 && abs(dye+(0.5*dy))<1e-6 ) 
         nee(ii,4)=k;
     end
     
     if(abs(dxe-0.5*dx)<1e-6 && abs(dye)<1e-6 ) 
         nee(ii,8)=k;
     end
     
     if (abs(dxe+(0.5*dx))<1e-6 && abs(dye+(0.5*dy))<1e-6)
          nee(ii,3)=k;
     end
     
    if (abs(dxe)<1e-6 && abs(dye+(0.5*dy))<1e-6)
          nee(ii,7)=k;
     end
     
     if (abs(dxe+(0.5*dx))<1e-6 && abs(dye)<1e-6)
          nee(ii,6)=k;
     end
     
     if ((abs(dxe-0.5*dx)<1e-6 && abs(dye-0.5*dy)<1e-6))
          nee(ii,1)=k;
     end
      
     if((abs(dxe)<1e-6 && abs(dye-0.5*dy)<1e-6))
          nee(ii,5)=k;
     end
     
     if((abs(dxe+ (0.5*dx))<1e-6 && abs(dye-0.5*dy)<1e-6))
          nee(ii,2)=k;
     end
 
     end
     ii =ii +1;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%% conectividad presion %%%%%%%%%%%%%%%%%%%%
 for kii=1:nnp
     dxe = xi - xep(2*kii-1);
     dye = yi - xep(2*kii);
     
     if(abs(dxe-0.5*dx)<1e-6 && abs(dye+0.5*dy)<1e-6 )
         neep(iip,4)=kii;
     end
     
     if (abs(dxe+0.5*dx)<1e-6 && abs(dye+0.5*dy)<1e-6)
         neep(iip,3)=kii;
     end
     if ((abs(dxe-0.5*dx)<1e-6 && abs(dye-0.5*dy)<1e-6))
         neep(iip,1)=kii;
     end
     
     if((abs(dxe+0.5*dx)<1e-6 && abs(dye-0.5*dy)<1e-6))
         neep(iip,2)=kii;
     end
     
 end
 iip =iip +1;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
% axis([0.5*dx (Lx + 0.5*dx) 0.5*dy (Ly + 0.5*dy)])
nee;
ni=8;
xee=zeros(4,2);vgest=zeros(2*nn,1);
for i=1:net
   for j=1:ni
       xe(2*nee(i,j)-1); %#ok<NOEFF>
       xe(2*nee(i,j)); %#ok<NOEFF>
       if (j<=4)
       xee(j,1)=xe(2*nee(i,j)-1);
       xee(j,2)=xe(2*nee(i,j));
       end
       vgest(nee(i,j),1)=1e-9;
       vgest(nn+nee(i,j),1)=1e-9;
   end   
% xee = [0 0; 1 0; 1 1];
face = [1 2 3 4];
%figure
patch('Faces',face,'Vertices',xee,'EdgeColor','red','FaceColor','none','LineWidth',1);
hold on
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ur=zeros(3*nn,1);
%  ur(1:2*nn,1)=vgest;
for i=1:jnb
   ii=nbc(i,1);
    vgest(ii,1)=u(ii,1);
    vgest(nn+ii,1)=0.0;
    ur(ii,1)=u(ii,1);
    ur(nn+ii,1)=u(nn+ii,1); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 kee=zeros(2*nn+(nex+1)*(ney+1),2*nn+(nex+1)*(ney+1));
 qee=zeros(2*nn+(nex+1)*(ney+1),1);
 % kuu=zeros(nn,nn);
 % kvv=zeros(nn,nn);
 % kpex=zeros(nn,(nex+1)*(ney+1));
 % kpey=zeros(nn,(nex+1)*(ney+1));
 % kpext=zeros((nex+1)*(ney+1),nn);
 % kpeyt=zeros((nex+1)*(ney+1),nn);
 % kppe=zeros((nex+1)*(ney+1),(nex+1)*(ney+1));
 nfu=8;nfp=4;
%  pause
  for i=1:net
 % Kue=zeros(nfu,nfu);Kve=zeros(nfu,nfu);Kpx=zeros(nfu,nfp);kpy=zeros(nfu,nfp);
 % kux=zeros(nfp,nfu);kvy=zeros(nfp,nfu);kpp=zeros(nfp,nfp);
 % que=zeros(nfu,1);
 % kunee=zeros(nfu,nfu);
 % dfdx=zeros(nfu,2);
 % dfdxp=zeros(nfp,2);
 % f=zeros(nfu,1);fp=zeros(nfp,1);
 
% 
%   dxu=(xe(2*nee(i,5)-1)- xe(2*nee(i,1)-1));
%   dyu=(xe(2*nee(i,8))- xe(2*nee(i,1)));
% %  
% % % %pause
%    au=dxu/2;%(x(nei(i,1))-x(nei(i,2)))/2;
%    bu=dxu/2;%(x(nei(i,1))+x(nei(i,2)))/2;
%    cu=dyu/2;%(x(nei(i,1))-x(nei(i,2)))/2;
%    du=dyu/2;%(x(nei(i,1))+x(nei(i,2)))/2;
%    
%    dxp=(xe(2*nee(i,2)-1)- xe(2*nee(i,1)-1));
%    dyp=(xe(2*nee(i,4))- xe(2*nee(i,1)));
% %  
% % % %pause
%    ap=dxp/2;%(x(nei(i,1))-x(nei(i,2)))/2;
%    bp=dxp/2;%(x(nei(i,1))+x(nei(i,2)))/2;
%    cp=dyp/2;%(x(nei(i,1))-x(nei(i,2)))/2;
%    dp=dyp/2;%(x(nei(i,1))+x(nei(i,2)))/2;
   
 ni=2;
 xi=zeros(ni,2);
 wi=ones(ni,2);
 wi(:,1)=1;
%  wi(:,2)=8/9;
 xi(1,1)= -sqrt(1/3);%xi(2)=0;
 xi(1,2)=  -sqrt(1/3);
%  xi(2,1)=   0;%xi(2)=0;
%  xi(2,2)=   0;
 xi(2,1)=   sqrt(1/3);%xi(2)=0;
 xi(2,2)=   sqrt(1/3);
% % %  ke(:,:) =0.0;
% % 
% % 
% for k1=1:nf
%     int_k =0;
%     for ii=1:ni
%         for jj=1:ni
%             xii=(a*xi(ii,1)+b);
%             yii=(c*xi(jj,2)+d);
%             f(1)=(1-xii/dx)*(1-yii/dy);%dfdx(1,1)=-1/dx*(1-yii/dy);dfdx(1,2)=-(1-xii/dx)*1/dy;
%             f(2)= (xii/dx)*(1-yii/dy);%dfdx(2,1)=(1-yii/dy)*1/dx;dfdx(2,2)=-(xii/dx)*1/dy;
%             f(3)= (xii/dx)*(yii/dy);%dfdx(3,1)=(yii/dy)*1/dx;dfdx(3,2)=(xii/dx)*1/dy;
%             f(4)=(1-xii/dx)*(yii/dy);%dfdx(4,1)=1/dx;dfdx(4,2)=-1/dx;
%             
%             int_k =  int_k + dx/2*wi(ii)*(q*f(k1));
% %             int_k2 =  int_k2 + dx/2*wi(ii)*(q/kcoef*(a2*f(k2)));
%         end
%     end
% %     int_k
%     qe(k1,1)=int_k;
% end
% %  qe
% % qsur(i:i+1,1)=qsur(i:i+1,1)+qe(:,1);
% % 
% % int_k=0.0;     
Jacb=zeros(2,2);
  for k1=1:nfu
    for k2=1:nfu
%         
   int_k=0.0;     
 for ii=1:ni
      for jj=1:ni
     xii=(xi(ii,1));
     yii=(xi(jj,2));
     f(1)= 0.25*(1-xii)*(1-yii)*(-xii-yii-1);dfdx(1,1)=0.25*(1-yii)*(1+(2*xii-1)+yii);dfdx(1,2)=0.25*(1-xii)*(1+xii+(2*yii-1));
     f(2)= 0.25*(1+xii)*(1-yii)*(xii-yii-1);dfdx(2,1)=0.25*(1-yii)*((1+2*xii)-yii-1);dfdx(2,2)=0.25*(1+xii)*(-xii+(2*yii-1)+1);
     f(3)= 0.25*(1+xii)*(1+yii)*(xii+yii-1);dfdx(3,1)=0.25*(1+yii)*((1+2*xii)+yii-1);dfdx(3,2)=0.25*(1+xii)*(xii+(1+2*yii)-1);
     f(4)= 0.25*(1-xii)*(1+yii)*(-xii+yii-1);dfdx(4,1)=0.25*(1+yii)*((2*xii-1)-yii+1);dfdx(4,2)=0.25*(1-xii)*(-xii+(1+2*yii)-1);
     f(5)= 0.5*(1-xii^2)*(1-yii);dfdx(5,1)=-xii*(1-yii);dfdx(5,2)=-0.5*(1-xii^2);
     f(6)= 0.5*(1+xii)*(1-yii^2);dfdx(6,1)= 0.5*(1-yii^2);dfdx(6,2)=-yii*(1+xii);
     f(7)= 0.5*(1-xii^2)*(1+yii);dfdx(7,1)=-xii*(1+yii);dfdx(7,2)=0.5*(1-xii^2);
     f(8)= 0.5*(1-xii)*(1-yii^2);dfdx(8,1)=-0.5*(1-yii^2);dfdx(8,2)=-(1-xii)*yii;
     for j1=1:2
         jnx=0;jny=0;
             for i1=1:nfu
             jnx = jnx +xe(2*nee(i,i1)-1)*dfdx(i1,j1);
             jny = jny +xe(2*nee(i,i1))*dfdx(i1,j1);
             end
             Jacb(j1,1)=jnx; 
             Jacb(j1,2)=jny; 
     end
%      Jacb(1,1)=2/dx;Jacb(1,2)=0;Jacb(2,1)=0;Jacb(2,2)=2/dx;
     jd=det(Jacb);
     iJacob=inv(Jacb);
     dxx=(iJacob(1,1)*dfdx(k1,1) + iJacob(1,2)*dfdx(k1,2))*(iJacob(1,1)*dfdx(k2,1) + iJacob(1,2)*dfdx(k2,2) );
     dyy=(iJacob(2,1)*dfdx(k1,1) + iJacob(2,2)*dfdx(k1,2))*(iJacob(2,1)*dfdx(k2,1) + iJacob(2,2)*dfdx(k2,2) );
     
     int_k =  int_k + jd*wi(ii,1)*wi(jj,2)*(mu*dxx + mu*dyy);
      end
 end
 % kue(k1,k2)=int_k; %#ok<SAGROW>
 % kve(k1,k2)=int_k; %#ok<SAGROW>
%  
 % for ii=1:nn
 %     for jj=1:nn
 % 
 %       if(ii==nee(i,k1) && jj==nee(i,k2)) 
 %           kuu(ii,jj)=  kuu(ii,jj) + kue(k1,k2);
 %           kvv(ii,jj)=  kvv(ii,jj) + kve(k1,k2);
 %       end
 %     end
 % end

 ii=nee(i,k1); jj=nee(i,k2);
 kee(ii,jj)= kee(ii,jj) + int_k;
 kee(nn+ii,nn+jj)= kee(ii + nn,jj + nn) + int_k;
     % kuu(ii,jj)=  kuu(ii,jj) + int_k;
     % kvv(ii,jj)=  kvv(ii,jj) + int_k;

    end
  end
Jacb=zeros(2,2); Jacbp=zeros(2,2);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ni=2;
 xi=zeros(ni,2);
 wi=ones(ni,2);
 wi(:,1)=1;
% %  wi(2)=8/9;
 xi(1,1)= -sqrt(1/3);%xi(2)=0;
 xi(1,2)=  -sqrt(1/3);
 xi(2,1)=   sqrt(1/3);%xi(2)=0;
 xi(2,2)=  sqrt(1/3);
 
   for k1=1:nfu
    for k2=1:nfp
%         
   int_kpx=0.0; int_kpy=0.0;    int_kux=0.0;    int_kvy=0.0;        
 for ii=1:ni
      for jj=1:ni
      xii=(xi(ii,1));
     yii=(xi(jj,2));
     fp(1,1)= 0.25*(1-xii)*(1-yii);dfdxp(1,1)=-0.25*(1-yii);dfdpx(1,2)=-0.25*(1-xii);
     fp(2,1)= 0.25*(1+xii)*(1-yii);dfdxp(2,1)=0.25*(1-yii);dfdxp(2,2)=-0.25*(1+xii);
     fp(3,1)= 0.25*(1+xii)*(1+yii);dfdxp(3,1)=0.25*(1+yii);dfdxp(3,2)=0.25*(1+xii);
     fp(4,1)= 0.25*(1-xii)*(1+yii);dfdxp(4,1)=-0.25*(1+yii);dfdxp(4,2)=0.25*(1-xii);
     
     f(1)= 0.25*(1-xii)*(1-yii)*(-xii-yii-1);dfdx(1,1)=0.25*(1-yii)*(1+(2*xii-1)+yii);dfdx(1,2)=0.25*(1-xii)*(1+xii+(2*yii-1));
     f(2)= 0.25*(1+xii)*(1-yii)*(xii-yii-1);dfdx(2,1)=0.25*(1-yii)*((1+2*xii)-yii-1);dfdx(2,2)=0.25*(1+xii)*(-xii+(2*yii-1)+1);
     f(3)= 0.25*(1+xii)*(1+yii)*(xii+yii-1);dfdx(3,1)=0.25*(1+yii)*((1+2*xii)+yii-1);dfdx(3,2)=0.25*(1+xii)*(xii+(1+2*yii)-1);
     f(4)= 0.25*(1-xii)*(1+yii)*(-xii+yii-1);dfdx(4,1)=0.25*(1+yii)*((2*xii-1)-yii+1);dfdx(4,2)=0.25*(1-xii)*(-xii+(1+2*yii)-1);
     f(5)= 0.5*(1-xii^2)*(1-yii);dfdx(5,1)=-xii*(1-yii);dfdx(5,2)=-0.5*(1-xii^2);
     f(6)= 0.5*(1+xii)*(1-yii^2);dfdx(6,1)= 0.5*(1-yii^2);dfdx(6,2)=-yii*(1+xii);
     f(7)= 0.5*(1-xii^2)*(1+yii);dfdx(7,1)=-xii*(1+yii);dfdx(7,2)=0.5*(1-xii^2);
     f(8)= 0.5*(1-xii)*(1-yii^2);dfdx(8,1)=-0.5*(1-yii^2);dfdx(8,2)=-(1-xii)*yii;
     
     for j1=1:2
         jnx=0;jny=0;
             for i1=1:nfp
             jnx = jnx +xep(2*neep(i,i1)-1)*dfdxp(i1,j1);
             jny = jny +xep(2*neep(i,i1))*dfdxp(i1,j1);
             end
             Jacbp(j1,1)=jnx;
             Jacbp(j1,2)=jny;
             
              jnx=0;jny=0;
             for i1=1:nfu
             jnx = jnx +xe(2*nee(i,i1)-1)*dfdx(i1,j1);
             jny = jny +xe(2*nee(i,i1))*dfdx(i1,j1);
             end
             Jacb(j1,1)=jnx;
             Jacb(j1,2)=jny;
     end
%      Jacb(1,1)=2/dx;Jacb(1,2)=0;Jacb(2,1)=0;Jacb(2,2)=2/dx;
     jd=det(Jacb);  jdp=det(Jacbp);
     iJacob=inv(Jacb); iJacobp=inv(Jacbp);
     dxxp=(iJacobp(1,1)*dfdx(k2,1) + iJacobp(1,2)*dfdx(k2,2));
     dyyp=(iJacobp(2,1)*dfdx(k2,1) + iJacobp(2,2)*dfdx(k2,2));
     dxx=(iJacob(1,1)*dfdx(k1,1) + iJacob(1,2)*dfdx(k1,2));
     dyy=(iJacob(2,1)*dfdx(k1,1) + iJacob(2,2)*dfdx(k1,2));
     
     int_kpx =  int_kpx + jd*wi(ii,1)*wi(jj,2)*(dxx*fp(k2,1));
     int_kpy =  int_kpy + jd*wi(ii,1)*wi(jj,2)*(dyy*fp(k2,1));
     
     
%      int_kux =  int_kux + jd*wi(ii,1)*wi(jj,2)*(dxxp*f(k1,1)); 
%      int_kvy =  int_kvy + jd*wi(ii,1)*wi(jj,2)*(dyyp*f(k1,1));
      end
 end
%  kpx(k1,k2)=int_kpx;kpy(k1,k2)=int_kpy; %#ok<SAGROW>
%  kux(k2,k1)=int_kpx;kvy(k2,k1)=int_kpy;
% %  
%  for ii=1:nn
%      for jj=1:nnp
% 
%        if(ii==nee(i,k1) && jj==neep(i,k2)) 
%            kpex(ii,jj)=  kpex(ii,jj) + kpx(k1,k2);
%            kpey(ii,jj)=  kpey(ii,jj) + kpy(k1,k2);
% %        end
% %          if(ii==nee(i,k1) && jj==nee(i,k2)) 
%             kpext(jj,ii)=  kpext(jj,ii)+ kux(k2,k1) ;
%             kpeyt(jj,ii)=  kpeyt(jj,ii)+ kvy(k2,k1);
%         end
% 
%      end
%  end
%%
ii=nee(i,k1); jj=neep(i,k2);
kee(ii,jj + 2*nn)= kee(ii,jj+ 2*nn)              - int_kpx;
kee(ii + nn,jj + 2*nn)= kee(ii + nn,jj + 2*nn)   - int_kpy;

kee(jj + 2*nn, ii)     = kee(jj+ 2*nn,ii)        - int_kpx;
kee(jj + 2*nn, ii + nn)= kee(jj + 2*nn, ii + nn) - int_kpy;

% kpex(ii,jj)=  kpex(ii,jj) + kpx(k1,k2);
% kpey(ii,jj)=  kpey(ii,jj) + kpy(k1,k2);
% %        end
% %          if(ii==nee(i,k1) && jj==nee(i,k2)) 
%             kpext(jj,ii)=  kpext(jj,ii)+ kux(k2,k1) ;
%             kpeyt(jj,ii)=  kpeyt(jj,ii)+ kvy(k2,k1);

%%
    end
  end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Jacb=zeros(2,2); Jacbp=zeros(2,2);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ni=2;
%  xi=zeros(ni,2);
%  wi=ones(ni,2);
%  wi(:,1)=1;
% % %  wi(2)=8/9;
%  xi(1,1)= -sqrt(1/3);%xi(2)=0;
%  xi(1,2)=  -sqrt(1/3);
%  xi(2,1)=   sqrt(1/3);%xi(2)=0;
%  xi(2,2)=  sqrt(1/3);
% 
%    for k1=1:nfp
%     for k2=1:nfp
%         
%  int_kpp=0.d0;        
%  for ii=1:ni
%       for jj=1:ni
%       xii=(xi(ii,1));
%      yii=(xi(jj,2));
%      fp(1,1)= 0.25*(1-xii)*(1-yii);dfdxp(1,1)=-0.25*(1-yii);dfdpx(1,2)=-0.25*(1-xii);
%      fp(2,1)= 0.25*(1+xii)*(1-yii);dfdxp(2,1)=0.25*(1-yii);dfdxp(2,2)=-0.25*(1+xii);
%      fp(3,1)= 0.25*(1+xii)*(1+yii);dfdxp(3,1)=0.25*(1+yii);dfdxp(3,2)=0.25*(1+xii);
%      fp(4,1)= 0.25*(1-xii)*(1+yii);dfdxp(4,1)=-0.25*(1+yii);dfdxp(4,2)=0.25*(1-xii);
% 
%      for j1=1:2
%          jnx=0;jny=0;
%              for i1=1:nfp
%              jnx = jnx +xep(2*neep(i,i1)-1)*dfdxp(i1,j1);
%              jny = jny +xep(2*neep(i,i1))*dfdxp(i1,j1);
%              end
%              Jacbp(j1,1)=jnx;
%              Jacbp(j1,2)=jny;
% 
%      end
% %      Jacb(1,1)=2/dx;Jacb(1,2)=0;Jacb(2,1)=0;Jacb(2,2)=2/dx;
%       jdp=det(Jacbp);
%       iJacobp=inv(Jacbp);
% 
% 
%      int_kpp =  int_kpp + jdp*wi(ii,1)*wi(jj,2)*(fp(k1,1)*fp(k2,1));
% 
%       end
%  end
%  kpp(k1,k2)=int_kpp;
% 
%  for ii=1:nnp
%      for jj=1:nnp
% 
%        if(ii==neep(i,k1) && jj==neep(i,k2)) 
%            kppe(ii,jj)=  kppe(ii,jj) + kpp(k1,k2);
% 
%         end
% 
%      end
%  end
%     end
%   end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  end
%  kuu;
%  kpex;
% %  kpext=kpex';
%  kpey;
%  u;
%  pause
%  kpeyt=kpey';
%  pause
%  Kpex
%  Kpey
%  Kpext
%  Kpeyt
%  pause
% %  kee
for i=1:jnb
    %     if (nbc(i,2)==1)
    ii =nbc(i,1);
    kee(ii,:)=0.0;
    kee(ii,ii)=1.0;
    kee(ii+ nn,nn +1:2*nn)=0.0;
    kee(ii+ nn,ii+nn)=1.0;
    %          kpext(:,ii)=1.0;
    %          kpex(ii,:)=1.0;
    % %            kpex(ii,ii)=1.0;
    %          kpeyt(:,ii)=1.0;
    %          kpey(ii,:)=1.0;
    %             kpeyt(ii,ii)=1.0;
    %     end

end
% kuu
 qee=u;
%  qee
%   pause
  
%  kee(1:nn,1:nn)=kuu;
% %  kee(2*nn+1:2*nn+(nex+1)*(ney+1),2*nn+1:2*nn+(nex+1)*(ney+1))=kvv;
% %  kee(1:nn,nn+1:nn+(nex+1)*(ney+1))=-kpex;
% %  kee(2*nn+1:2*nn+(nex+1)*(ney+1),nn+1:nn+(nex+1)*(ney+1))=-kpey;
% %  kee(nn+1:nn+(nex+1)*(ney+1),1:nn)=-kpex';
% %  kee(nn+1:nn+(nex+1)*(ney+1),2*nn+1:2*nn+(nex+1)*(ney+1))=-kpey';
%  kee(nn+1:nn+nn,nn+1:nn+nn)=kvv;
%  kee(1:nn,2*nn+1:2*nn+(nex+1)*(ney+1))=-kpex;
%  kee(nn+1:2*nn,2*nn+1:2*nn+(nex+1)*(ney+1))=-kpey;
%  kee(2*nn+1:2*nn+(nex+1)*(ney+1),1:nn)=-kpext;
%  kee(2*nn+1:2*nn+(nex+1)*(ney+1),nn+1:2*nn)=-kpeyt;
%  kee(2*nn+1:2*nn+(nex+1)*(ney+1),2*nn+1:2*nn+(nex+1)*(ney+1))=kppe;
kee;
% inv(kee)
%  pause
%% 
u=(kee)\qee;
%%   pause
%% u=inv(kee)*qee; %#ok<MINV>
 usolx=zeros(nx,ny);
 usoly=zeros(nx,ny);
 Tintx = TriScatteredInterp( xe(1:2:2*nn - 1),xe(2:2:2*nn),u(1:nn),'natural'); %#ok<DTRIINT>
 Tinty = TriScatteredInterp( xe(1:2:2*nn - 1),xe(2:2:2*nn),u(nn+1:2*nn),'natural'); %#ok<DTRIINT>
 
% 
 ni = 70;dx = Lx/(ni - 1);
 [x y] = meshgrid(0:dx:Lx,0:dx:Lx);
 umx=zeros(ni,ni);umy=zeros(ni,ni);umm=zeros(ni,ni);
for i = 1: ni
    for j = 1:ni
        umx(i,j) = Tintx( x(i,j), y(i,j) );
        umy(i,j) = Tinty( x(i,j), y(i,j) );
        umm(i,j) = sqrt( umx(i,j)*umx(i,j)+umy(i,j)*umy(i,j) );
    end
end
figure; 
axes('FontSize',18,'LineWidth',1.5');
hold on;
contourf(x,y,umm)
axis([0 1 0 1]);
xlabel('x','FontSize',18)
ylabel('y','FontSize',18)
colorbar
hold off
figure; 
axes('FontSize',18,'LineWidth',1.5');
h2=quiver(x,y,umx,umy);
set(h2,'AutoScale','on', 'AutoScaleFactor',2.5)
axis([0 1 0 1.03]);
xlabel('x','FontSize',18)
ylabel('y','FontSize',18)
colorbar