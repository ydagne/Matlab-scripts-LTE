%------Geenerate sample hexagonal grid with the following parameters-------
Radius = 1;  % Cell radius (meters)
numOfLayers = 1;  % Number of layers
numOfRUs = 7;
RRUdist = 2/3;
plotData = true;  


cells = generateDAS(Radius, numOfLayers, numOfRUs, RRUdist, plotData);
