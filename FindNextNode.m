function [ Index ] = FindNextNode(NodesCoord,PrevNode,RefNode,TempNodes)
%  FindNextNode: finds the next node in the candidate region boudary
%                process. The next one (after the reference one) is picked
%                from the fixed set of nodes.
%
% INPUTS
%
%  NodesCoord     : nodes coordinates
%  PrevNode       : previous node
%  RefNode        : reference (current) node
%  TempNodes      : set of nodes
%
% OUTPUTS
%
%  Index          : index of the next node
%

P=NodesCoord(PrevNode,:);
S=NodesCoord(RefNode,:);
N=NodesCoord(TempNodes,:);


NoOfTempNodes=size(N,1);


SP=ones(NoOfTempNodes,1)*(P-S);
%SN=N-S

SN=N-ones(size(N,1),1)*S;

LenSP=sqrt(SP(:,1).^2+SP(:,2).^2);
LenSN=sqrt(SN(:,1).^2+SN(:,2).^2);


DotProd=SP(:,1).*SN(:,1)+SP(:,2).*SN(:,2);


Phi=acos(DotProd./(LenSP.*LenSN));

Temp=find(SP(:,1).*SN(:,2)-SP(:,2).*SN(:,1)<0);

Phi(Temp)=2*pi-Phi(Temp);

[~,Index]=min(Phi);



end

