#Virtual Tourist App #

##Objective
This app was created as part of my Udacity NanoDegree project

##Functionality##
This app allows users to click on a location anywhere in the world and it will download the photos for that location from Flickr. These images and pin locations are cached locally on the device using Core Data. 

##Elements Used##
- UIKit 
- MapKit 
- CoreData
- Network and API ( Flickr) 

##Advanced UI Interactions##
- I also played around the some more complex UI elements, such as touching and holding the map location after the pin was dropped to allow the user to relocate the pin. 
- I also added methods to automatically delete the cached images after a pin was deleted to make sure the app doesn't take up too much unnecessary storage on the device. ( and to be a good citizen)