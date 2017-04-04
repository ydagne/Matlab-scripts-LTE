%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cells = generateDAS(Radius, numOfLayers, numOfRUs, ...
                 RRUdist, plotData)
%
%  Populates a hexagonal grid with DAS radio units. In each cell there are
%  numOfRUs radio units deployed inside each hexagon. Except for the first
%  RU (which will be located at the cell center), the rest will be
%  uniformly deployed at a distance of Radius*RUdist
%
%
%  Input arguments:
%
%    Radius - cell radius
%    numOfLayers - number of cell layers.
%                         0 --> single cell
%                         1 --> one central cell and 6 neighbouring cells
%                         2 --> one central cell and 18 neighbouring cells
%                         .
%                         .
%    numOfRUs - number of radio units per cell
%    RRUdist  - normalized distance of remote radio units from cell center
%
%  Output:
%
%    cells - a structure array of multi-cell DAS deployments
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(Radius <= 0)
    error('generateDAS: cell radius must be positive real number');
end


if(numOfLayers < 0)
    error('generateDAS: numOfLayers must be positive integer');
end

if(numOfRUs < 1)
    error('generateDAS: numOfRUs must be positive integer');
end

if( (RRUdist < 0) || (RRUdist > sqrt(3)/2) )
    error('generateDAS: RRU distance should be in range [0, sqrt(3)/2]');
end

cellCoordinates = generateHexGrid(Radius, numOfLayers, plotData);

theta = ([0:numOfRUs-2]')*2*pi/(numOfRUs-1);
RUpos = [0,0; Radius*RRUdist*( [cos(theta), sin(theta)])];


for k=1:size(cellCoordinates,1)
    cells(k).RUs = repmat(cellCoordinates(k,:),numOfRUs,1) + RUpos;
end


if (plotData)

    figure('color','w');
    hold on;

    %////////////////////////////////////////
    %  Draw the hex grid
    cellBorder =  Radius*[cos([theta;theta(1)]), sin([theta;theta(1)])];
    for k=1:size(cellCoordinates,1)

        cellEdges = repmat(cellCoordinates(k,:),numOfRUs,1) + cellBorder;
        plot(cellEdges(:,1), cellEdges(:,2),'k');    
    end

    % Put RRUs
    markers = {'v:','v:','v:','v:'};
    colors = {'b','k','m','b','r','b','m'};
    for k=1:size(cellCoordinates,1)
        plot(cells(k).RUs(:,1), cells(k).RUs(:,2),markers{mod(k,4)+1}, ...
              'MarkerSize',8,'MarkerFaceColor',colors{mod(k,7)+1},...
              'LineWidth',1); 
    end
      
    xlabel('meters'); ylabel('meters');
    grid on;
    axis equal; 

end