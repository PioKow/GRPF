% Copyright (c) 2018 Gdansk University of Technology
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
%
% Author: Piotr Kowalczyk
% Project homepage: https://github.com/PioKow/GRPF
%

%
% main program GRPF
%
close all;
clear;
clc;
format long;

analysis_parameters; % input file

NodesCoord=[];
NrOfNodes=0;

%% general loop
it=0;
while it<ItMax&&NrOfNodes<NodesMax
    it=it+1;
    
    NodesCoord=[NodesCoord ; NewNodesCoord];
    
    disp(['Evaluation of the function in ',num2str(size(NewNodesCoord,1)),' new points...'])
   
    for Node=NrOfNodes+1:NrOfNodes+size(NewNodesCoord,1)
        z=NodesCoord(Node,1)+1i*NodesCoord(Node,2);        
        FuntionValues(Node,1)=fun(z);% my function !!!!!!!!!!!!!!!!
        Quadrants(Node,1) = vinq( FuntionValues(Node,1) );
    end
    
    NewNodesCoord=[];
    NrOfNodes=size(NodesCoord,1);
    disp(['Triangulation and analysis of ',num2str(NrOfNodes),' nodes...'])
    
    opts=[];
    DT = delaunayTriangulation(NodesCoord(:,1),NodesCoord(:,2)); 
    Elements = DT.ConnectivityList;
    Edges = edges(DT);
    
    NrOfElements=size(Elements,1);
    
    PhasesDiff=mod(Quadrants(Edges(:,1))-Quadrants(Edges(:,2)),4);
    
    CandidateEdges=Edges(PhasesDiff==2|isnan(PhasesDiff),:);
       
    if isempty(CandidateEdges)
        disp('No roots in the domain!')
        return
    end
    
    Nodes1OfCandidateEdges=CandidateEdges(:,1);
    Nodes2OfCandidateEdges=CandidateEdges(:,2);
    
    CoordinatesOfNodes1OfCandidateEdges=NodesCoord(Nodes1OfCandidateEdges,:);
    CoordinatesOfNodes2OfCandidateEdges=NodesCoord(Nodes2OfCandidateEdges,:);
    
    CandidateEdgesLengths=sqrt(sum((CoordinatesOfNodes2OfCandidateEdges-CoordinatesOfNodes1OfCandidateEdges).^2,2));
    MinCandidateEdgesLengths=min(CandidateEdgesLengths);
    MaxCandidateEdgesLengths=max(CandidateEdgesLengths);
    disp(['Candidate edges length min: ' , num2str(MinCandidateEdgesLengths), ' max: ',num2str(MaxCandidateEdgesLengths)])
    
    if MaxCandidateEdgesLengths<Tol
        disp(['Assumed accuracy is achieved in iteration: ',num2str(it)])
        disp('----------------------------------------------------------------')
        
        break
    end       

    Temp=CandidateEdgesLengths>Tol;
    ReduCandidateEdges=CandidateEdges(Temp,:);

    Temp=zeros(NrOfNodes,1);
    Temp(ReduCandidateEdges(:,1))=1;
    Temp(ReduCandidateEdges(:,2))=1;
    CandidateNodes=find(Temp==1);
    
    ArrayOfCandidateElements = vertexAttachments(DT,CandidateNodes);
    Temp=zeros(NrOfElements,1);
    for k=1:size(ArrayOfCandidateElements,1)
        Temp(ArrayOfCandidateElements{k})=Temp(ArrayOfCandidateElements{k})+1;
    end 
    
    IDOfFirsrZoneCandidateElements=find(Temp>1);
    IDOfSecondZoneCandidateElements=find(Temp==1);
  
    NoOfFirsrZoneCandidateElements=size(IDOfFirsrZoneCandidateElements,1);
    FirsrZoneCandidateElements=Elements(IDOfFirsrZoneCandidateElements,:);    
    
        
    for k=1:NoOfFirsrZoneCandidateElements 
        
        TempExtraEdges((k-1)*3+1,:)=[FirsrZoneCandidateElements(k,1) FirsrZoneCandidateElements(k,2)];
        TempExtraEdges((k-1)*3+2,:)=[FirsrZoneCandidateElements(k,2) FirsrZoneCandidateElements(k,3)];
        TempExtraEdges((k-1)*3+3,:)=[FirsrZoneCandidateElements(k,3) FirsrZoneCandidateElements(k,1)];
        
    end
    
    
    NewNodesCoord=sum(NodesCoord(TempExtraEdges(1,:),:))/2;
    
    for k=2:3*NoOfFirsrZoneCandidateElements
        
        
        CoordOfTempEdgeNode1=NodesCoord(TempExtraEdges(k,1),:);
        CoordOfTempEdgeNode2=NodesCoord(TempExtraEdges(k,2),:);
        TempNodeCoord=(CoordOfTempEdgeNode1+CoordOfTempEdgeNode2)/2;
        TempEdgeLength=sqrt(sum((CoordOfTempEdgeNode2-CoordOfTempEdgeNode1).^2));
        
        if TempEdgeLength>Tol
            DistNodes=sqrt((NewNodesCoord(:,1)-TempNodeCoord(1)).^2 +(NewNodesCoord(:,2)-TempNodeCoord(2)).^2 );
            if sum(DistNodes<2*eps)==0
                NewNodesCoord=[NewNodesCoord ; TempNodeCoord];
            end
        end
        

    end
    
    
    % removing the first new node if the edge is too short
    CoordOfTempEdgeNode1=NodesCoord(TempExtraEdges(1,1),:);
    CoordOfTempEdgeNode2=NodesCoord(TempExtraEdges(1,2),:);
    TempEdgeLength=sqrt(sum((CoordOfTempEdgeNode2-CoordOfTempEdgeNode1).^2));
    if TempEdgeLength<Tol
        NewNodesCoord(1,:)=[];
        
    end

    NoOfSecondZoneCandidateElements=size(IDOfSecondZoneCandidateElements,1);
    SecondZoneCandidateElements=Elements(IDOfSecondZoneCandidateElements,:);    
        
    for k=1:NoOfSecondZoneCandidateElements 
        
        NodesInTempElement=SecondZoneCandidateElements(k,:);
        Node1Coord=NodesCoord(NodesInTempElement(1),:);
        Node2Coord=NodesCoord(NodesInTempElement(2),:);
        Node3Coord=NodesCoord(NodesInTempElement(3),:);
        TempLengths(1)=sqrt(sum((Node2Coord-Node1Coord).^2));
        TempLengths(2)=sqrt(sum((Node3Coord-Node2Coord).^2));
        TempLengths(3)=sqrt(sum((Node1Coord-Node3Coord).^2));
        if max(TempLengths)/min(TempLengths)>SkinnyTriangle
            TempNodeCoord=(Node1Coord+Node2Coord+Node3Coord)/3;
            NewNodesCoord=[NewNodesCoord ; TempNodeCoord];
        end
        
    end
    
    if visual==2
        figure(1)
        vis(NodesCoord, Edges, Quadrants,PhasesDiff)
        drawnow;
    end
    
    
    disp(['Iteration: ',num2str(it), ' done'])
    disp('----------------------------------------------------------------')
end

    if visual>0
        vis(NodesCoord, Edges, Quadrants,PhasesDiff)
        drawnow;
    end



% Evaluation of regions and verification 
disp('Evaluation of regions and verification...')


% Evaluation of contour edges from all candidates edges 
ArrayOfCandidateElements = edgeAttachments(DT,CandidateEdges(:,1),CandidateEdges(:,2));
Temp=zeros(NrOfElements,1);
for k=1:size(ArrayOfCandidateElements,1)
    Temp(ArrayOfCandidateElements{k})=1;
end

IDOfCandidateElements=find(Temp==1);
NoOfCandidateElements=size(IDOfCandidateElements,1);
CandidateElements=Elements(IDOfCandidateElements,:);

TempEdges=zeros(NoOfCandidateElements*3,2);

for k=1:NoOfCandidateElements
    TempEdges((k-1)*3+1,:)=[CandidateElements(k,1) CandidateElements(k,2)];
    TempEdges((k-1)*3+2,:)=[CandidateElements(k,2) CandidateElements(k,3)];
    TempEdges((k-1)*3+3,:)=[CandidateElements(k,3) CandidateElements(k,1)];
end



% Reduction of edges to contour
MultiplicationOfTempEdges=zeros(3*NoOfCandidateElements,1);
RevTempEdges=fliplr(TempEdges);
for k=1:3*NoOfCandidateElements
    if MultiplicationOfTempEdges(k)==0
        NoOfEdge=find(RevTempEdges(:,1)==TempEdges(k,1)&RevTempEdges(:,2)==TempEdges(k,2));
        if isempty(NoOfEdge)
            MultiplicationOfTempEdges(k)=1;
        else
            MultiplicationOfTempEdges(k)=2;
            MultiplicationOfTempEdges(NoOfEdge)=2;
        end
    end
end


ContourEdges=TempEdges(MultiplicationOfTempEdges==1,:);
NoOfContourEdges=size(ContourEdges,1);


% evaluation of the regions
NoOfRegions=1;
Regions{NoOfRegions}=ContourEdges(1,1);
RefNode=ContourEdges(1,2);
ContourEdges(1,:)=[];
while size(ContourEdges,1)>0
    IndexOfNextEdge=find(ContourEdges(:,1)==RefNode);
    
    if isempty(IndexOfNextEdge)
        Regions{NoOfRegions}=[Regions{NoOfRegions} RefNode];
        if size(ContourEdges,1)>0
            NoOfRegions=NoOfRegions+1;
            Regions{NoOfRegions}=ContourEdges(1,1);
            RefNode=ContourEdges(1,2);
            ContourEdges(1,:)=[];            
        end
    else
        if size(IndexOfNextEdge,1)>1
            
            IndexOfNextEdge;
            PrevNode= Regions{NoOfRegions}(end);
            TempNodes=ContourEdges(IndexOfNextEdge,2);            
            Index= FindNextNode(NodesCoord,PrevNode,RefNode,TempNodes);           
            IndexOfNextEdge=IndexOfNextEdge(Index);
   
        end
       
        NextEdge=ContourEdges(IndexOfNextEdge,:);
        Regions{NoOfRegions}=[Regions{NoOfRegions} ContourEdges(IndexOfNextEdge,1)];
        RefNode=ContourEdges(IndexOfNextEdge,2);
        ContourEdges(IndexOfNextEdge,:)=[];
    end
  
end
Regions{NoOfRegions}=[Regions{NoOfRegions} RefNode];


if visual>0
    figure(1);
    hold on
end

disp('Results:')
for k=1:NoOfRegions
    
   
    QuadrantSequence=Quadrants(Regions{k});

    dQ=QuadrantSequence(2:end)-QuadrantSequence(1:end-1);
    dQ(dQ==3)=-1;
    dQ(dQ==-3)=1;
    dQ(abs(dQ)==2)=NaN;
    q(k,1)=sum(dQ)/4;
    z(k,1)=mean(NodesCoord(Regions{k},1)+1i*NodesCoord(Regions{k},2));
    if visual>0
        line(NodesCoord(Regions{k},1) ,NodesCoord(Regions{k},2),'LineWidth',2,'Color','c');
    end
    disp(['Region: ',num2str(k),' z = ',num2str(z(k)),' with q = ',num2str(q(k)) ])
    
 end




z_root=z(q>0);
z_roots_multiplicity=q(q>0);

NoOfRoots=size(z_root,1);

disp('------------------------------------------------------------------' )

disp('Root and its multiplicity: ');

[z_root z_roots_multiplicity]



z_poles=z(q<0);
z_poles_multiplicity=q(q<0);

NoOfPoles=size(z_poles,1);

disp('------------------------------------------------------------------' )

disp('Poles and its multiplicity: ');

[z_poles z_poles_multiplicity]

















