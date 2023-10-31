// calculates the amount of grid elements need to fit a form - basically its: length / 42 rounded up
// but because the doesn't exist a round up function i had to improvise
function toGridfinityGridL(length) = (length/l_grid)+(1-((length/l_grid)%1));