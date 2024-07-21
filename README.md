For all the local-area-boundary files, I put them in a folder called "local-area-boundary" and places the folder on my desktop. 
The data was downloaded from the City of Vancouver website: https://opendata.vancouver.ca/explore/dataset/local-area-boundary/export/?disjunctive.name
[Under "Geographic file formats" -> "Shapefile" -> "Download Whole dataset"]

For all the Census data I had it on my desktop (feel free to change the path). I actually made edits to the Census data after I downloaded it from the City of Vancouver website where
a lot of the city collected data is stored. You can access the original file here: https://opendata.vancouver.ca/explore/dataset/census-local-area-profiles-2016/information/
[Under "Data Access" -> "Census local area profiles 2016 (CSV)"]

What I under from my code so far:
1) If the map is static, it works. It is my reactive elements that are making my app not work.
2) I need to add a leafletProxy() function to update my leaflet map but I don't know how to do it
3) For the commented out paletteNum() function I believe it is not working when it is reactive is because of how my input data is structure. This is just a guess though.
4) I need to make the fillColor in the addPolygons() function reactive
5) I need to make the values and title in the addLegend() function reactive
6) Whenever I change ```fillColor = ~paletteNum(vancouver$X0.to.14.years)``` manually to another agegroup like ```fillColor = ~paletteNum(vancouver$X5.to.9.years)```, it seems to work as intended but that is not reactive.
