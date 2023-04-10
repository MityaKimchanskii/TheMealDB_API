# TheMealDB API

* [+] Swift
* [+] UIKit
* [+] Animation
* [+] UnitTests
* [+] AutoLayout
* [+] Protocol-Delegate 
* [+] REST API
* [+] JSON
* [+] UICollectionView
* [+] UITableView 
* [+] UIScrollView
* [+] All views programmatically
* [+] No Storyboard
* [+] Git
* [+] GitHub

<img src='https://github.com/MityaKimchanskii/TheMealDB_API/blob/main/image.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## In project 4 endpoints:
* https://www.themealdb.com/api/json/v1/1/list.php?c=list - for fetching the list of categories.
* https://themealdb.com/api/json/v1/1/filter.php?c=Category - for fetching the list of meals in the selected category.
* https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID - for fetching the meal details by its ID.
* https://www.themealdb.com/images/media/meals/image.jpg - for fetching the image for each meal by its ID.

## Models or ViewModels
* In the project, we need to create the right model to work with the REST API and then parse the data to show it in the views. Create a model with Struct, then we need to confirm the Codable protocol. The Codable protocol has Decodable (converting JSON data to Swift) and Encodable (converting Swift data to JSON). We can only use Decodable. In the viewDidLoad method, we fetching all the categories and populate the UICollectionView. It is very important that when we are working with updating the view, we should only do it on the main thread, so we create the DispatchQueue.main.async method on the URLSession, because all the networking in the application happens on the background thread. To make model creation easier, we can use https://jsonviewer.stack.hu or a Google Chrome extension.

## ViewControllers
* CategoryListViewController to display a list of categories in a UICollectionView and a list of meals to display in a UITableView. To get the data we have to use URLSession which has a shared instance of the dataTask method (Singleton Pattern). Don't forget to resume(), this is very important, otherwise nothing will be retrieved. In the URLSession we have to check for an errors, then the data, and then try to decode. For all errors, we can create an Enum, this will help find the error if something goes wrong. Then when we select a cell in the UICollectionView we need to catch which category has been selected and the protoco-delegate pattern is best used for this purpose. To implement this pattern, we need to take a few steps. First we define a protocol, then we create a delegate in a class, then we find a place where we need to fire our delegate, then in another class where we want to know when the user clicks a UICollectionViewCell, we accept that protocol with a method, and then we can reload the UITableView with all information.
* DetailsViewController has a lot of information: image, instructions, ingredients, measures. We fetch the data using the id and update the image, nameLabel and UIScrollView. But first, we must check the received data again to find all empty or null values.

## Autolayout
* To create a view programmatically, we must first create the view, then set the translatesAutoresizingMaskIntoConstraints property to false, then add the view to the parent view, and then execute the NSLayoutConstrain.activate method. There are several ways to restrict views, but this one, in my opinion, is very nice and very readable.
