%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cellCoordinates = generateHexGrid(Radius, numOfLayers,plotData)
%  Generate a hexagonal grid
%
% 
% 
%                                _______
%                   \           /       \           /
%                    \         /  Radius \         /
%                     \_______/     ----->\_______/
%                     /       \           /       \
%                    /         \         /         \
%            _______/           \_______/           \_______
%           /       \           /       \           /       \
%          /         \         /   1st   \         /         \
%         /           \_______/   layer   \_______/     .     \
%         \           /       \           /       \     |     /
%          \         /   1st   \         /  1st    \    | Re-use distance
%           \_______/   layer   \_______/  layer    \___|___/
%           /       \           /       \           /   |   \
%          /         \         /         \         /    |    \         /
%         /           \_______/  Central  \_______/     v     \_______/
%         \           /       \    cell   /       \           /       \
%          \         /  1st    \         /  1st    \         /         \
%           \_______/  layer    \_______/  layer    \_______/ 
%           /       \           /       \           /       \
%          /         \         /  1st    \         /         \
%         /           \_______/  layer    \_______/           \
%         \           /       \           /       \           /
%          \         /         \         /         \         /
%           \_______/           \_______/           \_______/ 
%                   \           /       \           /
%                    \         /         \         /
%                     \_______/           \_______/
%                             \           /       \
%                              \         /         \
%                               \_______/           \
%
% Input arguments:
%     
%      Radius  -  cell radius
%                 For reuse 1, the reuse distance is sqrt(3)*Radius
%                 
%      numOfLayers - number of cell layers.
%                         0 --> single cell
%                         1 --> one central cell and 6 neighbouring cells
%                         2 --> one central cell and 18 neighbouring cells
%                         .
%                         .
%  Output:
%  
%       cellCoordinates - (x,y) coordinate of center of cells
%                         first entry is the central cell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                         
                        
                        
if(Radius < 0)
    error('generateHexGrid: Cell radius must be positive real number');
end

if(numOfLayers < 0)
    error('generateHexGrid: numOfLayers must be positive integer');
end
                
if(numOfLayers == 0) 
    
    cellCoordinates = [0,0];   % Single cell
    return;
    
else
    reuseDistance = sqrt(3)*Radius;
    
    columnOfCells = zeros((2*numOfLayers+3),2);
    columnOfCells(:,2) = [-(numOfLayers+1):(numOfLayers+1)]'*reuseDistance;
    
    coordinates = columnOfCells;   %  Initialize
    N = size(columnOfCells,1);
    
    for k = 1:numOfLayers
        
        if (mod(k,2)==1)
            lift = sqrt(3)*Radius/2;    
        else
            lift = 0;
        end
        
        left = columnOfCells +repmat([-1.5*k*Radius,lift],N,1);
        right = columnOfCells +repmat([1.5*k*Radius,lift],N,1);
        
        coordinates = [ coordinates; left;right];
        
    end
    
    cellDist = sqrt(sum(coordinates.^2, 2) );   % Distance from the orign
    
    tmp = [ coordinates, ...
            cellDist, ...
            floor(eps+cellDist/(1.5*Radius)), ...
            angle(coordinates(:,1) + 1j*coordinates(:,2) )];
    tmp = sortrows(tmp, [4,5]);
   
    
    % Distance of the farthest cell in the grid with "numOfLayers" 
    maxDist = Radius* sqrt( (1 + 1.5*numOfLayers)^2 + 3/4);
    
    %---------Pick only cells that lie inside the layer 
    cellCoordinates = tmp(tmp(:,3)<=maxDist, 1:2);
    
end

% if (plotData)
%     
%     figure('color','w');
% 
%     plot(cellCoordinates(:,1),cellCoordinates(:,2),'kp',...
%          'MarkerSize',15);
%     axis(1.2*[min(cellCoordinates(:,1)),max(cellCoordinates(:,1)), ...
%               min(cellCoordinates(:,2)),max(cellCoordinates(:,2))]);
%     hold on;
%     plot(cellCoordinates(:,1),cellCoordinates(:,2),'rv:',...
%          'MarkerSize',6, 'MarkerFaceColor','r','LineWidth',3);
%     grid on;
%     axis equal;
% end

% Plot cells individually
%////////////////////////////////////////

if(plotData)
    figure('color','w');
    hold on;

    theta = (0:6)'*2*pi/6;
    cellBorder =  Radius*[cos(theta), sin(theta)];
    for k=1:size(cellCoordinates,1)
        cellEdges = repmat(cellCoordinates(k,:),7,1) + cellBorder;
        plot(cellEdges(:,1), cellEdges(:,2),'k','LineWidth',2);    
    end

    xlabel('meters'); ylabel('meters');
    grid on;
    axis equal; 
end

