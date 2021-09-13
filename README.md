
<!-- README.md is generated from README.Rmd. Please edit that file -->

# marinedatashiny

<!-- badges: start -->

<!-- badges: end -->

Application is based on Marine data provided by kkkAPPSILON.  
There are two dropdown fields on SIDEBAR. Users can select ship type and
name by using these fields.  
There are 3 tabs on MAIN PANEL;  
1\. On “Map” tab: Users can see information about a selected ship’s
longest move.  
2\. On “Statistics” tab: Users can see summary statistics for average
distance and average speed.  
3\. On “Graphs” tab: Users can see the fastest 5 ships in selected ship
type

## Downloading Package

Latest version of the application can be downloaded from
[Github](https://github.com/) repository using the following command:

``` r
# install.packages("devtools")
devtools::install_github("gokhankocturk/gklfs")
```

## Data Description

**LAT** - ship’s latitude  
**LON** - ship’s longitude  
**SPEED** - ship’s speed in knots  
**COURSE** - ship’s course as angle  
**HEADING** - ship’s compass direction  
**DESTINATION** - ship’s destination (reported by the crew)  
**FLAG** - ship’s flag  
**LENGTH** - ship’s length in meters  
**SHIPNAME** - ship’s name  
**SHIPTYPE** - ship’s type  
**SHIP\_ID** - ship’s unique identifier  
**WIDTH** - ship’s width in meters  
**DWT** - ship’s deadweight in tones  
**DATETIME** - date and time of the observation  
**PORT** - current port reported by the vessel  
**Date** - date extracted from DATETIME  
**Week\_nb** - week number extracted from date  
**Ship\_type** - ship’s type from SHIPTYPE  
**Port** - current port assigned based on the ship’s location  
**Is\_parked** - indicator whether the ship is moving or not
